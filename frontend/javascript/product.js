const API_BASE_URL = 'http://localhost:61227/api';

var product = [];
var currentUserData;
var token = localStorage.getItem('token');
var currentPage = 1;
const reviewsPerPage = 5;
var totalReviews = 0;
var reviewList = [];
var tokenRefreshInterval;

var productName = encodeURIComponent(new URLSearchParams(window.location.search).get('name'));

document.addEventListener('DOMContentLoaded', async () => {
    currentUserData = await fetchJson(`${API_BASE_URL}/user/me`)

    product = await fetchJson(`${API_BASE_URL}/product/byname?name=${productName}&userId=${currentUserData.id}`);

    if(product){
        renderProduct(product);
        loadReviews();
        await updateFavorites();
        updateCart();
    }else{
        document.querySelector('.product-container').innerHTML = `<p>A termék nem található!</p>`;
    }

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

async function loadProduct(productName) {
    product = await fetchJson(`${API_BASE_URL}/product/byname?name=${productName}&userId=${currentUserData.id}`);
    renderProduct(product);
    loadReviews();
}

function renderProduct(product) {
    const favoriteIcon = product.saved ? 'resources/svg/favoritepicked.svg' : 'resources/svg/favoritebase.svg';
    
    document.getElementById('productContainer').innerHTML = `
    <div class="product-layout">
        <div class="product-image-container">
            <img class="product-image clickable" src="${product.imageUrl}" alt="${product.name}" onclick="openImageModal(this.src)">
        </div>
        <div class="product-details">
            <img class="favorite-btn" src="${favoriteIcon}" alt="Kedvenc" onclick="toggleFavorite(${product.id})">
            <div class="product-title">${product.name}</div>
            <div class="product-description">${product.description}</div>
            <div class="product-price">${product.price.toLocaleString()} Ft</div>
            <div class="product-stock">Készleten: ${product.stockQuantity} db</div>
            <button class="add-to-cart-btn" onclick="addToCart(${product.id})">Tedd kosárba</button>
        </div>
    </div>`;
}

async function toggleFavorite(productId) {
    try{
        await fetchJson(`${API_BASE_URL}/favorite/toggle`,'POST',{ UserId: currentUserData.id, ProductId: productId })
        product.saved = !product.saved;
        const img = document.querySelector('.favorite-btn');
        if(product.saved){
            img.src = 'resources/svg/favoritepicked.svg';
            showAlert('Termék kedvencekhez téve!', 'success');
        }else{
            img.src = 'resources/svg/favoritebase.svg';
            showAlert('Termék eltávolítva a kedvencekből!', 'success');
        }
        await updateFavorites();
    }catch{
        showAlert('Nem sikerült a terméket a kedvencekhez helyezni!', 'error');
    }
}

async function updateFavorites() {
    var userFavoritesCount = await fetchJson(`${API_BASE_URL}/favorite/count/${currentUserData.id}`);
    document.getElementById('favoriteCount').textContent = userFavoritesCount.count;
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

function calculateTotal() {
const cartItems = JSON.parse(localStorage.getItem('cart')) || [];
return cartItems.reduce((total, item) => total + (item.price * item.quantity), 0).toFixed(2);
}

function toggleCartPopup() {
const cartPopup = document.getElementById('cartPopup');
cartPopup.style.display = cartPopup.style.display === 'block' ? 'none' : 'block';
}

async function loadReviews(page = 1, reset = false) {
    try {
        const response = await fetchJson(`${API_BASE_URL}/productreview/byname?productName=${productName}&page=${page}&limit=${reviewsPerPage}`);

        totalReviews = response.totalCount;

        if (reset) {
            currentPage = 1;
            reviewList = response.reviews;
        } else {
            reviewList = [...reviewList, ...response.reviews];
        }

        const reviewsContainer = document.getElementById('reviewsContainer');
        reviewsContainer.innerHTML = reviewList.length
            ? reviewList.map(review => `
                <div class="review">
                    <div><strong><a href="user.html?username=${encodeURIComponent(review.userName)}"> ${review.userName}</a></strong></div>
                    <div><strong>Értékelés:</strong> ${'★'.repeat(review.rating)}${'☆'.repeat(5 - review.rating)}</div>
                    <div><strong>Vélemény:</strong> ${review.reviewText}</div>
                    <div><small>${review.createdAt}</small></div>
                </div>
            `).join('')
            : `<p>Nincsenek vélemények ehhez a termékhez.</p>`;

        const loadMoreBtn = document.getElementById('loadMoreBtn');
        if (reviewList.length < totalReviews) {
            loadMoreBtn.style.display = 'block';
        } else {
            loadMoreBtn.style.display = 'none';
        }
    } catch{
        document.getElementById('reviewsContainer').innerHTML = `<p>Nem sikerült betölteni a véleményeket.</p>`;
    }
}

async function loadMoreReviews() {
    currentPage++;
    await loadReviews(currentPage);
}

async function submitReview() {
    const reviewText = document.getElementById('reviewText').value;
    const rating = document.querySelector('input[name="rating"]:checked')?.value;
    
    if (!reviewText || !rating) {
        alert('Kérlek, töltsd ki a véleményedet és válassz értékelést!');
        return;
    }
    
    try {
        await fetchJson(`${API_BASE_URL}/productreview`,'POST',{UserId: currentUserData.id,ProductId: product.id,Rating: parseInt(rating),ReviewText: reviewText});

        
        document.getElementById('reviewText').value = '';
        document.querySelector('input[name="rating"]:checked').checked = false;
        await loadReviews(1, true);
    } catch {
        showAlert('Hiba történt a vélemény beküldésekor.', 'error')
    }
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

function openImageModal(src) {
    const modal = document.createElement('div');
    modal.className = 'image-modal';
    modal.innerHTML = `<img src='${src}' alt='Nagyított kép' onclick='event.stopPropagation()'>`;

    modal.addEventListener('click', () => {
        modal.remove();
        document.body.style.overflow = '';
    });
    document.body.appendChild(modal);
    document.body.style.overflow = 'hidden';
}


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