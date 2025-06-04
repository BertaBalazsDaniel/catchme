const API_BASE_URL = 'http://localhost:61227/api';
var currentUserData;
var token = localStorage.getItem('token');
var tokenRefreshInterval = null;
var currentPage = 1;
const postsPerPage = 3;
var totalPosts = 0;
var postsData = [];
var currentCommentPage = 1;
const commentsPerPage = 5;
var allComments = [];
var totalComments = 0;
var currentPostId;

const urlParams = new URLSearchParams(window.location.search);
const category = urlParams.get('category') || 'Fogások';

document.addEventListener('DOMContentLoaded', async () => {
    [currentUserData, postsData] = await Promise.all([
        fetchJson(`${API_BASE_URL}/user/me`),
        fetchJson(`${API_BASE_URL}/post/category/${category}?page=${currentPage}&limit=${postsPerPage}`)
    ]);

    if(category !== 'Fogások' && category !== 'Tippek' && category !== 'Horgászhelyek'){
        document.querySelector('.post-container').innerHTML = `<p>A megadott kategória nem található</p>`;
    }else{
        totalPosts = postsData.totalCount;

        if(totalPosts !== 0){
            renderPosts(false);
        }else{
            document.getElementById('communityPostContainer').innerHTML += `<p>Nincsenek bejegyzések ehhez a kategóriához!</p>`;
        }

        highlightActiveMenu(category);
        document.getElementById('currentUserPage').href = `user.html?username=${encodeURIComponent(currentUserData.username)}`;
        document.querySelector('.add-post-button').style.display = 'block';
        const postForm = document.querySelector('.post-form');
        if (postForm) {
            postForm.addEventListener('submit', (event) => {
                event.preventDefault();
                submitPost(category, currentUserData.username);
            });
        }
    }
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
        
        if (!response.ok) throw new Error(`Hiba a lekérés során: ${url}`);
    
        if(method !== 'DELETE'){
            return response.json();
        }else{
return response;
        }

    }catch{
        showAlert('Szerver oldali hiba! Átirányítás a kezdőlapra...','error');
        setTimeout(() =>{
            window.location.href = 'authorisation.html';
        },5000)
    }
}

async function loadMorePosts() {
    currentPage++;
    const response = await fetchJson(`${API_BASE_URL}/post/category/${category}?page=${currentPage}&limit=${postsPerPage}`);
    postsData.posts = [...postsData.posts, ...response.posts];
    renderPosts(true);
}

function renderPosts(append = false) {
    const container = document.getElementById('communityPostContainer');

    if (!append) container.innerHTML = '';

    postsData.posts.forEach(post => {
        if (append && document.getElementById(`post-${post.id}`)) return;

        const postDiv = document.createElement('div');
        postDiv.id = `post-${post.id}`;
        postDiv.className = 'post clickable';
        postDiv.onclick = () => openCommunityPostModal(post.id);
        postDiv.innerHTML = `
        <div class="post-header">
            <img src="./${post.profileImage || 'resources/default-profile.png'}" alt="Profilkép" class="profile-picture">
            <div class="user-info">
                <a href="user.html?username=${encodeURIComponent(post.userName)}" class="user-link">${post.userName}</a>
                <div class="post-date">${new Date(post.createdAt).toLocaleString()}</div>
            </div>
        </div>
        <p class="post-content">${post.content}</p>
        ${post.imageUrl ? `<img src="${post.imageUrl}" alt="${post.content}" class="post-image" onclick="event.stopPropagation(); openImageModal('${post.imageUrl}','${post.content}')">` : ''}
        <div class="post-meta">
            ${post.commentCount || 0} hozzászólás
            ${post.userId === currentUserData.id ? `<button class="delete-post-btn" onclick="event.stopPropagation(); deletePost(${post.id})">Törlés</button>` : ''}
        </div>`;
    

        container.appendChild(postDiv);
    });

    document.getElementById('loadMoreBtn').style.display =
        postsData.posts.length < totalPosts ? 'flex' : 'none';
}

function highlightActiveMenu(category) {
    document.querySelectorAll('#sidebar ul li').forEach(item => item.classList.remove('active'));
    const categoryIdMap = {
        'Fogások': 'menu-catches',
        'Tippek': 'menu-tips',
        'Horgászhelyek': 'menu-fishing-spots'
    };
    const activeMenuItemId = categoryIdMap[category];
    if (activeMenuItemId) {
        document.getElementById(activeMenuItemId).classList.add('active');
    }
}

async function openCommunityPostModal(postId) {
    currentPostId = postId;
    const post = postsData.posts.find(p => p.id == postId);
    if (!post) {
        showAlert('Nem található a bejegyzés.', 'error')
        return;
    }

    const postComments = await fetchJson(`${API_BASE_URL}/comment/${postId}/${currentUserData.id}?page=1&limit=${commentsPerPage}`);
    allComments = postComments.comments;
    totalComments = postComments.totalCount;
    currentCommentPage = 1;


    var commentsHtml = allComments.length ? allComments.map(comment => {
        return `
            <div class="comment" id="comment-${comment.id}">
                <div class="comment-header">
                    <img src="${comment.user.profileImage || 'resources/default-profile.png'}" alt="Profilkép" class="profile-picture">
                    <div class="user-info">
                        <a href="user.html?username=${encodeURIComponent(comment.user.username)}" class="user-link">${comment.user.username}</a>
                        <div class="comment-date">${new Date(comment.createdAt).toLocaleString()}</div>
                    </div>
                </div>
                <div class="comment-body">${comment.content}</div>
                <div class="comment-actions">
                    <button class="like-btn ${comment.userLike === 'Like' ? 'active-like' : ''}" onclick="likeComment(${comment.id}, 'Like', ${postId})" data-comment-id="${comment.id}" data-like-type="like">👍 ${comment.likes}</button>
                    <button class="like-btn ${comment.userLike === 'DisLike' ? 'active-dislike' : ''}" onclick="likeComment(${comment.id}, 'DisLike', ${postId})" data-comment-id="${comment.id}" data-like-type="dislike">👎 ${comment.disLikes}</button>
                </div>
            </div>`;
    }).join('') : '<p>Nincsenek hozzászólások ehhez a bejegyzéshez.</p>';

    const modalContent = document.getElementById('modalPostContent');

    modalContent.innerHTML = `
<div class="post-header">
    <img src="${post.profileImage || 'resources/default-profile.png'}" alt="Profilkép" class="profile-picture">
    <div class="user-info">
        <a href="user.html?username=${encodeURIComponent(post.userName)}" class="user-link">${post.userName}</a>
        <div class="post-date">${new Date(post.createdAt).toLocaleString()}</div>
    </div>
</div>
<p class="post-content">${post.content}</p>
${post.imageUrl ? `<img src="${post.imageUrl}" alt="${post.content}" class="post-image" onclick="event.stopPropagation(); openImageModal('${post.imageUrl}','${post.content}')">` : ''}
    <div class="comment-form">
        <textarea id="commentContent" placeholder="Írd ide a hozzászólásodat..." rows="4"></textarea>
        <button onclick="submitComment(${postId})">Hozzászólás küldése</button>
    </div>
    <div class="comments-section">
        <h3>Hozzászólások</h3>
        ${commentsHtml}
    </div>
    <button id="loadMoreCommentsBtn" onclick="loadMoreComments()">Több hozzászólás betöltése</button>`;

    document.getElementById('loadMoreCommentsBtn').style.display = totalComments < 6 ? 'none' : 'flex';

    document.body.style.overflow = 'hidden';
    const modal = document.getElementById('communityPostModal');
    modal.classList.remove('hidden');
    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });
}

function closeModal() {
    document.getElementById('communityPostModal').classList.add('hidden');
    document.getElementById('postAddModal').classList.add('hidden');
    document.body.style.overflow = '';
}

async function loadMoreComments() {
    currentCommentPage++;
    const response = await fetchJson(`${API_BASE_URL}/comment/${currentPostId}/${currentUserData.id}?page=${currentCommentPage}&limit=${commentsPerPage}`);
    allComments = [...allComments, ...response.comments];

    totalComments = response.totalCount;

    renderCommentsSection(true);
}

function renderCommentsSection(append = false) {
    const commentsSection = document.querySelector('.comments-section');
    if (!commentsSection) return;

    if (!append) commentsSection.innerHTML = '<h3>Hozzászólások</h3>';

    allComments.forEach(comment => {
        if (document.getElementById(`comment-${comment.id}`)) return;

        const commentDiv = document.createElement('div');
        commentDiv.id = `comment-${comment.id}`;
        commentDiv.className = 'comment';
        commentDiv.innerHTML = `
            <div class="comment-header">
                <img src="${comment.user.profileImage || 'resources/default-profile.png'}" alt="Profilkép" class="profile-picture">
                <div class="user-info">
                    <a href="user.html?username=${encodeURIComponent(comment.user.username)}" class="user-link">${comment.user.username}</a>
                    <div class="comment-date">${new Date(comment.createdAt).toLocaleString()}</div>
                </div>
            </div>
            <div class="comment-body">${comment.content}</div>
            <div class="comment-actions">
                <button class="like-btn ${comment.userLike === 'Like' ? 'active-like' : ''}" onclick="likeComment(${comment.id}, 'Like', ${currentPostId})" data-comment-id="${comment.id}" data-like-type="like">👍 ${comment.likes}</button>
                <button class="like-btn ${comment.userLike === 'DisLike' ? 'active-dislike' : ''}" onclick="likeComment(${comment.id}, 'DisLike', ${currentPostId})" data-comment-id="${comment.id}" data-like-type="dislike">👎 ${comment.disLikes}</button>
            </div>`;
        commentsSection.appendChild(commentDiv);
    });

    document.getElementById('loadMoreCommentsBtn').style.display = allComments.length < totalComments ? 'block' : 'none';
}

async function submitComment(postId) {
    const commentContent = document.getElementById('commentContent').value.trim();
    if (!commentContent) {
        showAlert('A hozzászólás nem lehet üres!','error');
        return;
    }

    const newComment = {
        postId,
        userId: currentUserData.id,
        content: commentContent,
    };

    try {
        await fetchJson(`${API_BASE_URL}/comment`,'POST',newComment)
        document.getElementById('commentContent').value = '';

        const post = postsData.posts.find(p => p.id === postId);
        if (post) {
            post.commentCount = (post.commentCount || 0) + 1;
            const postDiv = document.getElementById(`post-${postId}`);
            if (postDiv) {
                const postMetaDiv = postDiv.querySelector('.post-meta');
                if (postMetaDiv) {
                    postMetaDiv.innerHTML = `
                        ${post.commentCount} hozzászólás
                        ${post.userId === currentUserData.id ? `<button class="delete-post-btn" onclick="event.stopPropagation(); deletePost(${post.id})">Törlés</button>` : ''}
                    `;
                }
            }
        }

        openCommunityPostModal(postId);
    } catch{
        showAlert('Hálózati hiba történt.', 'error')
    }
}

async function likeComment(commentId, likeType, postId) {
    const userId = currentUserData.id;
    const comment = allComments.find(c => c.id === commentId);
    const currentLike = comment?.userLike;

    try {
        if (currentLike === likeType) {
            await fetchJson(`${API_BASE_URL}/commentlike/${userId}/${commentId}`, 'DELETE');
            updateCommentLikeCount(commentId, likeType, -1);
            comment.userLike = null;
        } else {
            await fetchJson(`${API_BASE_URL}/commentlike`, 'POST', {
                UserId: userId,
                CommentId: commentId,
                LikeType: likeType
            });

            if (currentLike){
                updateCommentLikeCount(commentId, currentLike, -1);
            }
            updateCommentLikeCount(commentId, likeType, 1);
            comment.userLike = likeType;
        }
    } catch{
        showAlert('Nem sikerült a szavazás.','error');
        return;
    }

    updateLikeButtonColor(commentId, likeType, currentLike, postId);
}

function updateLikeButtonColor(commentId, likeType, currentLike, postId) {
    const upvoteButton = document.querySelector(`button[data-comment-id="${commentId}"][data-like-type="like"]`);
    const downvoteButton = document.querySelector(`button[data-comment-id="${commentId}"][data-like-type="dislike"]`);

    if (likeType === 'Like' && upvoteButton) {
        upvoteButton.classList.add('active-like');
        downvoteButton?.classList.remove('active-dislike');
    }

    if (likeType === 'DisLike' && downvoteButton) {
        downvoteButton.classList.add('active-dislike');
        upvoteButton?.classList.remove('active-like');
    }

    if (currentLike === likeType) {
        if (likeType === 'Like') upvoteButton?.classList.remove('active-like');
        if (likeType === 'DisLike') downvoteButton?.classList.remove('active-dislike');
    }
}

function updateCommentLikeCount(commentId, likeType, change) {
    const selector = `button[data-comment-id='${commentId}'][data-like-type='${likeType.toLowerCase()}']`;
    const button = document.querySelector(selector);
    const comment = allComments.find(c => c.id === commentId);

    if (!button || !comment) return;

    var currentCount = likeType === 'Like' ? comment.likes : comment.disLikes;
    const newCount = currentCount + change;

    if (likeType === 'Like') comment.likes = newCount;
    else comment.disLikes = newCount;

    const emoji = likeType === 'Like' ? '👍' : '👎';
    button.textContent = `${emoji} ${newCount}`;
}

async function submitPost(category) {
    const contentInput = document.getElementById('postContent');
    const imageInput = document.getElementById('postImage');

    if (!contentInput.value) {
        showAlert('A tartalom kötelező!','error');
        return;
    }

    const formData = new FormData();
    formData.append('content', contentInput.value);
    formData.append('category', category);
    formData.append('userId', currentUserData.id);

    const selectedFile = imageInput.files[0];
    if (selectedFile) {
        formData.append('image', selectedFile);
    }

    try {
        const response = await fetch('/frontend/upload_post.php', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            currentPage = 1;
            postsData = await fetchJson(`${API_BASE_URL}/post/category/${category}?page=${currentPage}&limit=${postsPerPage}`);
            totalPosts = postsData.totalCount;

            contentInput.value = '';
            imageInput.value = '';
            closeModal();
            renderPosts(false);
        }

    } catch{
        showAlert('Hálózati hiba történt!','error')
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById('postAddModal');
    const openModalButton = document.getElementById('openPostAddModal');

    openModalButton.addEventListener('click', () => {
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    });

    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });
});

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

function openImageModal(src,alt) {
    const modal = document.createElement('div');
    modal.className = 'image-modal';

    const image = document.createElement('img');
    image.src = src;
    image.alt = alt;

    image.addEventListener('click', (event) => {
        event.stopPropagation();
    });

    modal.appendChild(image);

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


async function deletePost(postId) {
    if (!confirm('Biztosan törölni szeretnéd ezt a posztot?')) return;

    try {
        await fetchJson(`${API_BASE_URL}/post/${postId}`, 'DELETE');
        showAlert('A poszt sikeresen törölve lett.', 'success');

        currentPage = 1;
        postsData = await fetchJson(`${API_BASE_URL}/post/category/${category}?page=${currentPage}&limit=${postsPerPage}`);
        totalPosts = postsData.totalCount;

        if (totalPosts === 0) {
            document.getElementById('communityPostContainer').innerHTML = `<p>Nincsenek bejegyzések ehhez a kategóriához!</p>`;
        } else {
            renderPosts(false);
        }

    } catch (error) {
        showAlert('Hiba történt a törlés során!', 'error');
    }
}