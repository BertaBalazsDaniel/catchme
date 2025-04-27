const script = document.createElement('script');
script.src = 'https://www.paypal.com/sdk/js?client-id=Ac6AjM2rBB-CJzMZ6PRYxMDLhU8t85yIKLQXJLlx765gnu4OBFI0sOtgncf2E95ZNyq9lRESeToIyfo3&currency=HUF';
script.onload = function () {
    paypal.Buttons({
        style: {
            layout: 'vertical',
            color: 'blue',
            shape: 'rect',
            label: 'paypal',
        },
        createOrder: async function (data, actions) {
            const totalAmount = cartItems
                .reduce((total, item) => total + (item.productPrice * item.quantity), 0)
                .toFixed(2);
        
            return actions.order.create({
                intent: 'CAPTURE',
                application_context: {
                    shipping_preference: 'GET_FROM_FILE',
                    user_action: 'PAY_NOW'
                },             
                purchase_units: [{
                    amount: {
                        currency_code: 'HUF',
                        value: totalAmount
                    }
                }]
            });
        },      
        onApprove: async function (data, actions) {
            const details = await actions.order.capture();
            const shipping = details.purchase_units?.[0].shipping.address;
            const address = `${shipping.country_code}, ${shipping.postal_code} ${shipping?.admin_area_2}, ${shipping.address_line_1 + (shipping.address_line_2 ? ' ' + shipping.address_line_2 : '')}`;
            const phone = details.payer?.phone?.phone_number?.national_number;

            return actions.order.capture().then(async function (details) {
        
                const orderData = {
                    UserId: currentUserData.id,
                    Email: details.payer.email_address,
                    FullName: details.payer.name.given_name + ' ' + details.payer.name.surname,
                    AddressLine: address,
                    PhoneNumber: phone?.match(/^[0-9\-\+]{9,15}$/) ? phone : '+36301234567',
                    TotalAmount: cartItems.reduce((sum, item) => sum + item.productPrice * item.quantity, 0),
                    PayPalTransactionId: details.id
                };

                const orderResponse = await fetchJson(`${API_BASE_URL}/order`,'POST',orderData);
        
                const orderId = orderResponse.id;
        
                for (const item of cartItems) {
                    await fetchJson(`${API_BASE_URL}/orderitem`,'POST',{OrderId: orderId,ProductId: item.productId,Quantity: item.quantity,Price: item.productPrice});
                }


                const cartDetails = cartItems.map(item =>
                    `- ${item.productName} x ${item.quantity} = ${item.productPrice * item.quantity} Ft`
                ).join('\n');
                
                emailjs.send('service_effxgm9', 'template_phrfghp', {
                    name: orderData.FullName,
                    email: orderData.Email,
                    address: orderData.AddressLine,
                    phone: orderData.PhoneNumber,
                    transactionId: orderData.PayPalTransactionId,
                    orderDate: new Date().toLocaleString('hu-HU'),
                    totalAmount: orderData.TotalAmount.toLocaleString(),
                    cartItems: cartDetails
                })
                .catch(showAlert('Nem sikerült a megerősítő e-mail küldése!','error'));
        
                showAlert(`Köszönjük a vásárlást, ${details.payer.name.given_name} ${details.payer.name.surname}!`,'success');
                await clearCart();
                setTimeout(() => {
                    window.location.href = 'order.html';
                }, 3000);
            });
        },
        onCancel: function () {
            showAlert('A fizetés megszakítva!','error');
        }
    }).render('#paypal-button-container');
};
document.head.appendChild(script);


const API_BASE_URL = 'http://localhost:61227/api';
var cartItems = [];
var currentUserData;
var token = localStorage.getItem('token');
var tokenRefreshInterval;

document.addEventListener('DOMContentLoaded', async () => {
    currentUserData = await fetchJson(`${API_BASE_URL}/user/me`);
    cartItems = await fetchJson(`${API_BASE_URL}/cartitem/${currentUserData.username}`);

    if(cartItems){
        document.querySelector('.cart-summary').style.display = 'block';
        renderCartItems();
    }else{
        document.querySelector('.cart-summary').style.display = 'none';
    }
    
    scheduleTokenRefresh();
    document.getElementById('currentUserPage').href = `user.html?username=${encodeURIComponent(currentUserData.username)}`;
});

async function fetchJson(url,method = 'GET', options){
    try{
        var response;
        if(method === 'GET' || method === 'DELETE'){
            response = await fetch(url,{
                method: `${method}`,
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
        }else{
            response = await fetch(url,{
                method: `${method}`,
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(options)
            });
        }
    
        if (response.status === 401) {
            const data = await response.json();
            if (data.error === 'expired_token') {
                alert('A bejelentkezési idő lejárt, kérlek jelentkezz be újra!');
                localStorage.removeItem('token');
                window.location.href = 'authorisation.html';
                return;
            }
        }

        if(response.status === 404){
            return null;
        }
        
        if (!response.ok) throw new Error(`Hiba a lekérés során: ${url}`);
    
        return response.json();
    }catch{
        showAlert('Szerver oldali hiba! Átirányítás a kezdőlapra...','error');
        setTimeout(() =>{
            window.location.href = 'authorisation.html';
        },5000)
    }
}

function renderCartItems() {
    const container = document.getElementById('cartItemsContainer');

    container.innerHTML = cartItems.length ? cartItems.map((item, index) => `
        <div class='cart-item'>
        ${item.imageUrl ? `<img src='${item.imageUrl || 'resources/img/default-image.jpg'}' alt='${item.productName}' class='cart-item-image'>` : ''}
            <div class='cart-item-details'>
            <a href="product.html?name=${encodeURIComponent(item.productName)}">
                <span class='cart-item-name'>${item.productName}</span>
            </a>
                <div class='quantity-controls'>
                    <button onclick='updateQuantity(${index}, -1)'>-</button>
                    <span>${item.quantity}</span>
                    <button onclick='updateQuantity(${index}, 1)'>+</button>
                </div>
                <span class='cart-item-price'>${(item.productPrice * item.quantity).toLocaleString()} Ft</span>
            </div>
            <button class='delete-item' onclick='removeItem(${index})'>Törlés</button>
        </div>
    `).join('') : '<p>A kosár üres.</p>';

    document.getElementById('totalPrice').innerText = `${cartItems.reduce((sum, item) => sum + (item.productPrice * item.quantity), 0).toLocaleString()} Ft`;
}

function updateQuantity(index, darab) {
    if (!cartItems[index]) return;

    cartItems[index].quantity += darab;
    if (cartItems[index].quantity <= 0) removeItem(index);
    else updateItem(cartItems[index]);
    
    renderCartItems();
}

async function updateItem(cartItem) {
    try {
        await fetchJson(`${API_BASE_URL}/cartitem/${currentUserData.username}/${cartItem.productId}`,'PUT',{ quantity: cartItem.quantity })
        showAlert('A termékszám frissítése sikeres volt!','success');
    } catch (error) {
        showAlert('A termékszám frissítése nem sikerült!','error');
    }
}

async function removeItem(index) {
    if (!cartItems[index]) return;

    try {
        await fetchJson(`${API_BASE_URL}/cartitem/${currentUserData.username}/${cartItems[index].productId}`,'DELETE')
        cartItems.splice(index, 1);
        showAlert('Termék sikeresen törölve a kosárból!','success');
        renderCartItems();
    } catch (error) {
        showAlert('A termék törlése nem sikerült!','error')
    }
}

async function clearCart() {
    await fetchJson(`${API_BASE_URL}/cartitem/clear/${currentUserData.username}`,'DELETE')
    cartItems = [];
    renderCartItems();
}

function scheduleTokenRefresh() {
    if (!token) return;

    const decoded = atob(token).split('.');
    const expiryTime = parseInt(decoded[2]);
    const now = Math.floor(Date.now() / 1000);
    const secondsUntilExpiration = expiryTime - now;

    const refreshBeforeExpiration = 300;
    const refreshTime = (secondsUntilExpiration - refreshBeforeExpiration) * 1000;

    if (secondsUntilExpiration <= refreshBeforeExpiration) {
        refreshToken(); 
        return;
    }

    if (tokenRefreshInterval) clearTimeout(tokenRefreshInterval);
    tokenRefreshInterval = setTimeout(refreshToken, refreshTime);
}

async function refreshToken() {
    var data = await fetchJson(`${API_BASE_URL}/user/refreshtoken`,'POST',)
    token = data.token;
    localStorage.setItem('token', token);
    scheduleTokenRefresh();
}

window.addEventListener('beforeunload', () => {
    clearTimeout(tokenRefreshInterval);
});

function showPayPalModal() {
    document.querySelector('.paypal-overlay').style.display = 'flex';
}

document.addEventListener('DOMContentLoaded', () => {
    const overlay = document.querySelector('.paypal-overlay');
    overlay.addEventListener('click', (e) => {
        if (e.target === overlay) {
            overlay.style.display = 'none';
        }
    });
});

function showAlert(message, type = 'info', duration = 3000) {
    const existing = document.querySelector('.universal-alert');
    if (existing) existing.remove();

    const alertBox = document.createElement('div');
    alertBox.className = `universal-alert alert-${type}`;
    alertBox.innerText = message;
    document.body.appendChild(alertBox);

    setTimeout(() => {
        alertBox.classList.add('fade-out');
        setTimeout(() => alertBox.remove(), 300);
    }, duration);
}