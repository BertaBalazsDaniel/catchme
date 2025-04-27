const API_BASE_URL = 'http://localhost:61227/api';
var categories = [];
var productsData = [];
var currentUserData;
var token = localStorage.getItem('token');
var selectedFilters = {};
const productsPerPage = 10;
var currentPage = 1;
var selectedSort = { sortBy: null, sortOrder: 'asc' };
var tokenRefreshInterval = null;

document.addEventListener('DOMContentLoaded', async () => {
    const [userResponse, categoriesResponse ] = await Promise.all([
        fetchJson(`${API_BASE_URL}/user/me`),
        fetchJson(`${API_BASE_URL}/product/filters`)
    ]);
    currentUserData = userResponse;
    categories = categoriesResponse.categories;

    var productsResponse = await fetchFilteredProducts({}, 1, productsPerPage);

    totalProducts = productsResponse.totalCount || 0;
    productsData = productsResponse.products;

    document.getElementById('currentUserPage').href = `user.html?username=${encodeURIComponent(currentUserData.username)}`;

    updateFavorites();
    renderProducts(productsData);
    updateCart();
    renderCategoryFilters();
    updateLoadMoreButton();
    scheduleTokenRefresh();
    var modal = document.getElementById('filter-modal')
    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeFilterModal();
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

function renderProducts(newProducts, append = false) {
    const grid = document.getElementById('productGrid');
    if (!append) grid.innerHTML = '';

    if(newProducts.length>0){
        newProducts.forEach(p => {
            const isFavorite = p.saved;
            const favoriteIcon = isFavorite ? 'resources/svg/favoritepicked.svg' : 'resources/svg/favoritebase.svg';


            const productElement = document.createElement('div');
            productElement.className = 'product';
            productElement.innerHTML = `
                <img class="favorite-btn" src="${favoriteIcon}" alt="Kedvenc" onclick="toggleFavorite('${p.id}')">

                <a href="product.html?name=${encodeURIComponent(p.name)}">
                <img class="product-image" src="${p.imageUrl}" alt="${p.name}">
                </a>
                <div class="product-info">
                    <p class="product-name">${p.name}</p>
                    <div class="product-price">
                        ${p.oldPrice ? `<span class="old-price">${p.oldPrice.toLocaleString()} Ft</span>` : ''}
                        <span class="current-price">${p.price.toLocaleString()} Ft</span>
                    </div>
                    <div class="product-cart">
                        <button class="add-to-cart-btn" onclick="addToCart('${p.id}')">Kosárba tesz</button>
                    </div>
                </div>`;
            grid.appendChild(productElement);
        });
    }
    else{
        grid.innerHTML = `<p>Nem található termék</p>`;
    }
}

async function loadMoreProducts() {
    currentPage++;
    const response = await fetchFilteredProducts(selectedFilters, currentPage, productsPerPage);

    if (!response.products || response.products.length === 0) {
        document.getElementById('loadMoreBtn').style.display = 'none';
        return;
    }

    totalProducts = response.totalCount;
    productsData = [...productsData, ...response.products];

    renderProducts(response.products, true);


    updateLoadMoreButton();
}

function updateLoadMoreButton() {
    if (productsData.length < totalProducts) {
        document.getElementById('loadMoreBtn').style.display = 'block';
    } else {
        document.getElementById('loadMoreBtn').style.display = 'none';
    }
}

async function toggleFavorite(productId) {
    try{
        var toggle = await fetchJson(`${API_BASE_URL}/favorite/toggle`,'POST',{ UserId: currentUserData.id, ProductId: productId });
    
        const productElement = document.querySelector(`img.favorite-btn[onclick="toggleFavorite('${productId}')"]`);
    
        if (toggle.message === 'Kedvenc hozzáadva.') {
            productElement.src = 'resources/svg/favoritepicked.svg';
            showAlert('Termék kedvencekhez téve!', 'success');
        } else if (toggle.message === 'Kedvenc eltávolítva.') {
            productElement.src = 'resources/svg/favoritebase.svg';
            showAlert('Termék eltávolítva a kedvencekből!', 'success');
        }

        updateFavorites();
    }catch{
        showAlert('Nem sikerült a terméket a kedvencekhez helyezni!', 'error');
    }
    
}

async function updateFavorites() {
    var userFavoritesCount = await fetchJson(`${API_BASE_URL}/favorite/count/${currentUserData.id}`);
    document.getElementById('favoriteCount').textContent = userFavoritesCount.count;
}

function renderAttributeFilters(attributes) {
    const filterContainer = document.getElementById('filters');
    filterContainer.innerHTML = '';

    for (const [key, values] of Object.entries(attributes)) {
        const filterGroup = document.createElement('div');
        filterGroup.innerHTML = `<strong>${key}:</strong>`;

        const allValuesAreNumeric = values.every(v => {
            const numbersInValue = v.match(/\d+([.,]\d+)?/g);
            return numbersInValue && numbersInValue.length === 1;
        });


        if (allValuesAreNumeric && values.length >= 5) {
            const numericValues = values
                .map(v => parseFloat(v.trim().split(' ')[0].replace(',', '.')))
                .filter(v => !isNaN(v));
        
            const unit = values[0].trim().split(' ').slice(1).join(' ') || '';
        
            const min = Math.min(...numericValues);
            const max = Math.max(...numericValues);
            const hasDecimal = numericValues.some(num => !Number.isInteger(num));
            const step = hasDecimal ? 0.1 : 1;
        
            const rangeWrapper = document.createElement('div');
            rangeWrapper.innerHTML = `
                <input type="range" min="${min}" max="${max}" value="${max}" step="${step}" class="attr-slider" data-key="${key}">
                <span class="attr-slider-value">${max} ${unit}</span>`;
        
            const slider = rangeWrapper.querySelector('input');
            const valueDisplay = rangeWrapper.querySelector('span');
            slider.addEventListener('input', () => {
                const val = parseFloat(slider.value).toFixed(hasDecimal ? 1 : 0);
                valueDisplay.textContent = `${val} ${unit}`;
                if (!selectedFilters.attributes) selectedFilters.attributes = {};
                selectedFilters.attributes[key] = val;
            });
        
            filterGroup.appendChild(rangeWrapper);
            filterContainer.appendChild(filterGroup);
            return;
        }
        

        values.forEach(value => {
            const block = document.createElement('div');
            block.className = 'filter-block';
            block.innerText = value;
            block.addEventListener('click', () => selectFilter(block, key));
            filterGroup.appendChild(block);
        });

        filterContainer.appendChild(filterGroup);
    }
}

function updatePriceRangeUI(minPrice, maxPrice) {
    const priceSlider = document.getElementById('price-slider');
    const priceDisplay = document.getElementById('price-display');

    if (minPrice === maxPrice || minPrice === 0) {
        document.getElementById('price-range').style.display = 'none';
        return;
    }

    const step = 100;
    const correctedMin = Math.ceil(minPrice / step) * step;
    const correctedMax = Math.ceil(maxPrice / step) * step;

    priceSlider.min = correctedMin;
    priceSlider.max = correctedMax;
    priceSlider.step = step;
    priceSlider.value = correctedMax;

    priceDisplay.textContent = `${correctedMax.toLocaleString('hu-HU')} Ft`;
    document.getElementById('price-range').style.display = 'block';
}


document.getElementById('price-slider').addEventListener('input', function () {
    document.getElementById('price-display').textContent = `${parseInt(this.value).toLocaleString()} Ft`;
});

function renderCategoryFilters() {
    const categoryContainer = document.getElementById('category-filters');
    categoryContainer.innerHTML = '';

    if (!categories || categories.length === 0) {
        categoryContainer.innerHTML = '<p>Nincsenek elérhető kategóriák.</p>';
        return;
    }

    categories.forEach(category => {
        BuildCategoryTree(category, categoryContainer, 0);
    });
}

function BuildCategoryTree(category, parentElement, level) {
    const wrapper = document.createElement('div');
    wrapper.className = 'category-wrapper';
    wrapper.style.marginLeft = `${level * 10}px`;

    const categoryDiv = document.createElement('div');
    categoryDiv.className = level === 0 ? 'category-block' : 'subcategory-block';
    categoryDiv.innerText = category.name;
    categoryDiv.dataset.id = category.id;
    categoryDiv.style.cursor = 'pointer';

    const childrenContainer = document.createElement('div');
    childrenContainer.className = 'subcategory-container';
    childrenContainer.style.display = 'none';

    categoryDiv.addEventListener('click', (e) => {
        e.stopPropagation();

        if (category.subCategories && category.subCategories.length > 0) {
            document.querySelectorAll('.category-block.selected, .subcategory-block.selected')
                .forEach(el => el.classList.remove('selected'));

            if (childrenContainer.style.display === 'block') {
                childrenContainer.style.display = 'none';
            } else {
                const siblingWrappers = parentElement.querySelectorAll('.category-wrapper');
                siblingWrappers.forEach(sib => {
                    const container = sib.querySelector('.subcategory-container');
                    if (container && container !== childrenContainer) {
                        container.style.display = 'none';
                    }
                });

                childrenContainer.style.display = 'block';
                categoryDiv.classList.add('selected');
            }
        } else {
            document.querySelectorAll('.category-block.selected, .subcategory-block.selected')
                .forEach(el => el.classList.remove('selected'));

            categoryDiv.classList.add('selected');
            selectCategory(category);
        }
    });

    wrapper.appendChild(categoryDiv);
    wrapper.appendChild(childrenContainer);
    parentElement.appendChild(wrapper);

    if (category.subCategories && category.subCategories.length > 0) {
        category.subCategories.forEach(sub => {
            BuildCategoryTree(sub, childrenContainer, level + 1);
        });
    }
}


function selectCategory(category) {
    currentCategoryId = category.id;

    if (!category.attributes || Object.keys(category.attributes).length === 0) {
        document.getElementById('filters').innerHTML = '<p class="warning">Nincsenek termékek a kategóriában.</p>';
        document.getElementById('price-range').style.display = 'none';
        document.getElementById('apply-filters').style.display = 'none';
        return;
    }

    document.getElementById('apply-filters').style.display = 'block';
    renderAttributeFilters(category.attributes);
    updatePriceRangeUI(category.minPrice, category.maxPrice);
}

function toggleSubcategories(category, categoryDiv) {
    document.querySelectorAll('.subcategory-block.selected').forEach(block => block.classList.remove('selected'));

    document.querySelectorAll('.category-block').forEach(block => {
        if (block !== categoryDiv) {
            block.classList.remove('selected');
            const otherSubcategories = block.nextElementSibling;
            if (otherSubcategories && otherSubcategories.classList.contains('subcategory-container')) {
                otherSubcategories.style.display = 'none';
            }
        }
    });

    var subcategoryContainer = categoryDiv.nextElementSibling;

    if (!subcategoryContainer || !subcategoryContainer.classList.contains('subcategory-container')) {
        subcategoryContainer = document.createElement('div');
        subcategoryContainer.className = 'subcategory-container';
        subcategoryContainer.style.display = 'none';
        categoryDiv.after(subcategoryContainer);

        if (category.subcategories.length === 0) {
            document.getElementById('filters').innerHTML = '<p class="warning">Nincsenek alkategóriák a kategóriában.</p>';
            return;
        }

        category.subcategories.forEach(subcategory => {
            var subDiv = document.createElement('div');
            subDiv.className = 'subcategory-block';
            subDiv.innerText = subcategory.name;
            subDiv.dataset.id = subcategory.id;

            subDiv.addEventListener('click', (e) => {
                e.stopPropagation();
                selectCategory(subcategory);
            });

            subcategoryContainer.appendChild(subDiv);
        });
    }

    if (categoryDiv.classList.contains('selected')) {
        categoryDiv.classList.remove('selected');
        subcategoryContainer.style.display = 'none';
        clearFilters();
    } else {
        categoryDiv.classList.add('selected');
        subcategoryContainer.style.display = 'block';
        clearFilters();
    }
}

function selectFilter(block, key) {
    const allBlocks = block.parentNode.querySelectorAll('.filter-block');
    if (block.classList.contains('selected')) {
        block.classList.remove('selected');
    } else {
        allBlocks.forEach(el => el.classList.remove('selected'));
        block.classList.add('selected');
    }
}

document.getElementById('filterInput').addEventListener('input', async (event) => {
    currentPage = 1;
    const searchTerm = event.target.value.trim().toLowerCase();
    const response = await fetchFilteredProducts({ search: searchTerm }, currentPage, productsPerPage);

    totalProducts = response.totalCount;
    productsData = response.products;

    document.getElementById('productGrid').innerHTML = '';
    renderProducts(productsData);
    updateLoadMoreButton();
});

function openFilterModal() {
    document.getElementById('filter-modal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closeFilterModal() {
    document.getElementById('filter-modal').style.display = 'none';

    document.querySelectorAll('.category-block.selected, .subcategory-block.selected').forEach(el => el.classList.remove('selected'));

    document.querySelectorAll('.subcategory-container').forEach(container => container.style.display = 'none');

    document.getElementById('filters').innerHTML = '';
    document.getElementById('price-range').style.display = 'none';
    document.getElementById('apply-filters').style.display = 'none';
    document.body.style.overflow = '';
}

async function applyFilters() {
    const selected = {
        categoryId: currentCategoryId,
        maxPrice: parseInt(document.getElementById('price-slider').value) || null,
        attributes: {}
    };

    document.querySelectorAll('.filter-block.selected').forEach(block => {
        const key = block.parentNode.querySelector('strong').innerText.replace(':', '');
        selected.attributes[key] = block.innerText;
    });

    document.querySelectorAll('.attr-slider').forEach(slider => {
        const key = slider.dataset.key;
        const value = slider.value;
        selected.attributes[key] = value;
    });

    try {
        currentPage = 1;
        const response = await fetchFilteredProducts(selected, currentPage, productsPerPage);
        totalProducts = response.totalCount;
        productsData = response.products;

        document.getElementById('productGrid').innerHTML = '';
        renderProducts(productsData);

        if (productsData.length < totalProducts) {
            document.getElementById('loadMoreBtn').style.display = 'block';
        } else {
            document.getElementById('loadMoreBtn').style.display = 'none';
        }

        closeFilterModal();
        selectedFilters = { ...selected };
    } catch (error) {
        showAlert('Nem sikerült a szűrés!','error')
    }
}

async function fetchFilteredProducts(filters = {}, page = 1, limit = 10) {
    var query = `page=${page}&limit=${limit}&userId=${currentUserData.id}`;

    if (filters.search) {
        query += `&search=${encodeURIComponent(filters.search)}`;
    }
    if (filters.categoryId) {
        query += `&categoryId=${filters.categoryId}`;
    }
    if (filters.maxPrice) {
        query += `&maxPrice=${filters.maxPrice}`;
    }
    if (filters.attributes && Object.keys(filters.attributes).length > 0) {
        const attrString = Object.entries(filters.attributes)
            .map(([key, value]) => `${key}:${value}`)
            .join(',');
        query += `&attributes=${encodeURIComponent(attrString)}`;
    }
    if (selectedSort.sortBy) {
        query += `&sortBy=${selectedSort.sortBy}&sortOrder=${selectedSort.sortOrder}`;
    }    

    return await fetchJson(`${API_BASE_URL}/product/filter?${query}`);
}

document.getElementById('sortSelect').addEventListener('change', async (event) => {
    const value = event.target.value;

    if (!value) {
        selectedSort = { sortBy: null, sortOrder: 'asc' };
    } else {
        const [sortBy, sortOrder] = value.split('-');
        selectedSort = { sortBy, sortOrder };
    }

    try {
        currentPage = 1;
        const response = await fetchFilteredProducts(selectedFilters, currentPage, productsPerPage);
        productsData = response.products;
        totalProducts = response.totalCount;

        document.getElementById('productGrid').innerHTML = '';
        renderProducts(productsData);
        updateLoadMoreButton();
    } catch (error) {
        showAlert('Nem sikerült a rendezés!','error')
    }
});

async function clearFilters() {
    selectedFilters = {};
    currentPage = 1;
    document.getElementById('filterInput').value = '';
    document.querySelectorAll('.filter-block.selected').forEach(block => block.classList.remove('selected'));
    
    document.getElementById('filters').innerHTML = '';
    document.getElementById('price-range').style.display = 'none';
    document.getElementById('apply-filters').style.display = 'none';

    try {
        const response = await fetchFilteredProducts({}, currentPage, productsPerPage);
        totalProducts = response.totalCount;
        productsData = response.products;

        document.getElementById('productGrid').innerHTML = '';
        renderProducts(productsData);

        updateLoadMoreButton();
    } catch (error) {
        showAlert('Nem sikerült a szűrők törlése!','error')
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