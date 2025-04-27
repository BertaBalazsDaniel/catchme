const API_BASE_URL = 'http://localhost:61227/api';
var userFavorites = [];
var currentUserData;
var token = localStorage.getItem('token');
var tokenRefreshInterval;

document.addEventListener('DOMContentLoaded', async () => {
    currentUserData = await fetchJson(`${API_BASE_URL}/user/me`);
    userFavorites = await fetchJson(`${API_BASE_URL}/favorite/${currentUserData.id}`);
    renderFavorites();
    updateCart();
    document.getElementById('currentUserPage').href = `user.html?username=${encodeURIComponent(currentUserData.username)}`;
    scheduleTokenRefresh();
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

function renderFavorites() {
    const grid = document.getElementById('favoritesGrid');

    if (userFavorites.length === 0) {
        grid.innerHTML = '<p>Nincsenek kedvencek.</p>';
        return;
    }

    grid.innerHTML = userFavorites.map(fav => `
        <div class="product">
            <img class="favorite-btn" src="resources/svg/favoritepicked.svg" alt="Kedvenc" 
                     onclick="toggleFavorite('${fav.productId}')">

            <a href="product.html?name=${encodeURIComponent(fav.product.name)}">
            ${fav.product.imageUrl ? `<img class="product-image" src="${fav.product.imageUrl}" alt="${fav.product.name}">` : ''}
            </a>
            <div class="product-info">
                <p class="product-name">${fav.product.name}</p>
                <div class="product-price">
                    ${fav.product.oldPrice ? `<span class="old-price">${fav.product.oldPrice.toLocaleString()} Ft</span>` : ''}
                    <span class="current-price">${fav.product.price.toLocaleString()} Ft</span>
                </div>
                <div class="product-cart">
                    <button class="add-to-cart-btn" onclick="addToCart('${fav.product.id}')">Kosárba tesz</button>
                </div>
            </div>
        </div>
    `).join('');
}

async function toggleFavorite(productId) {
    try{
        await fetchJson(`${API_BASE_URL}/favorite/toggle`,'POST',{ UserId: currentUserData.id, ProductId: productId });
        showAlert('Termék eltávolítva a kedvencekből!', 'success');
        userFavorites = userFavorites.filter(fav => fav.productId != productId);
        renderFavorites();
    }catch{
        showAlert('Nem sikerült a terméket a kedvencekhez helyezni!', 'error');
    }
    
}

async function addToCart(productId) {
    try{
        await fetchJson(`${API_BASE_URL}/cartitem`,'POST',{ UserId: currentUserData.id, ProductId: productId, Quantity: 1 })
        showAlert('Termék kosárba téve!', 'success');
        updateCart();
    }catch{
        showAlert('Nem sikerült a terméket a kosárba helyezni!', 'error');
    }
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