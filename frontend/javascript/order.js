const API_BASE_URL = 'http://localhost:61227/api';
var userOrders = [];
var currentUserData;
var token = localStorage.getItem('token');
var tokenRefreshInterval;

document.addEventListener('DOMContentLoaded', async () => {
    currentUserData = await fetchJson(`${API_BASE_URL}/user/me`);
    [userFavorites, userOrders] = await Promise.all([
        fetchJson(`${API_BASE_URL}/favorite/count/${currentUserData.id}`),
        fetchJson(`${API_BASE_URL}/order/user/${currentUserData.id}`)
    ]);

    if(userOrders){
        renderOrders();
    }else{
        document.getElementById('ordersGrid').innerHTML = `<p>Nincsenek rendelések.</p>`;
    }

    document.getElementById('favoriteCount').textContent = userFavorites.count;
    updateCart();
    document.getElementById('currentUserPage').href = `user.html?username=${encodeURIComponent(currentUserData.username)}`;
    scheduleTokenRefresh();
    const modal = document.getElementById('orderModal');

    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            document.getElementById('orderModal').classList.add('hidden');
        }
    });
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

        if (response.status === 404) {
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

function renderOrders() {
    const grid = document.getElementById('ordersGrid');

    if (userOrders.length === 0) {
        grid.innerHTML = '<p>Nincsenek korábbi rendeléseid.</p>';
        return;
    }

    grid.innerHTML = userOrders.map(order => `
        <div class="order" onclick="openOrderModal(${order.id})">
            <h3>Rendelés #${order.payPalTransactionId}</h3>
            <p>Dátum: ${order.orderDate}</p>
            <p>Összeg: ${order.totalAmount.toLocaleString()} Ft</p>
            <p>Állapot: ${order.orderStatus}</p>
            <p>Fizetési státusz: ${order.paymentStatus}</p>
        </div>
    `).join('');
}

async function updateCart() {
    const cartItems = await fetchJson(`${API_BASE_URL}/cartitem/${currentUserData.username}`);
    if(cartItems){
        document.getElementById('cartCount').textContent = cartItems.reduce((sum, item) => sum + item.quantity, 0);
        document.getElementById('cartItems').innerHTML = cartItems.length ? cartItems.map(i => `
            <li>${i.productName} (${i.quantity} db) - ${i.productPrice.toLocaleString()} Ft/db</li>
        `).join('') : '<li>A kosár üres.</li>';
    }
}

function toggleCartPopup() {
    const cartPopup = document.getElementById('cartPopup');
    cartPopup.style.display = cartPopup.style.display === 'block' ? 'none' : 'block';
}

function openOrderModal(orderId) {
    const order = userOrders.find(o => o.id === orderId);
    if (!order) return;

    const modal = document.getElementById('orderModal');
    const modalContent = document.getElementById('orderModalContent');

    modalContent.innerHTML = `
        <h2>Rendelés #${order.payPalTransactionId}</h2>
        <p><strong>Név:</strong> ${order.fullName}</p>
        <p><strong>Email:</strong> ${order.email}</p>
        <p><strong>Dátum:</strong> ${order.orderDate}</p>
        <p><strong>Fizetési dátum:</strong> ${order.paymentDate}</p>
        <p><strong>Szállítási cím:</strong> ${order.addressLine}</p>
        <p><strong>Telefonszám:</strong> ${order.phoneNumber}</p>
        <p><strong>Állapot:</strong> ${order.orderStatus}</p>
        <p><strong>Összeg:</strong> ${order.totalAmount.toLocaleString()} Ft</p>
        <h3>Termékek:</h3>
        <ul>
            ${order.products.map(p => `
                <li>
                    <a href="product.html?name=${encodeURIComponent(p.name)}">${p.name}</a>
                    (${p.quantity} db) - ${p.price.toLocaleString()} Ft
                </li>
            `).join('')}
        </ul>`;
    modal.classList.remove('hidden');
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

function showAlert(message, type, duration = 3000) {
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