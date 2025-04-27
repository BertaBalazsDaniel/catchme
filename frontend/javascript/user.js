const API_BASE_URL = 'http://localhost:61227/api';
var currentUserData = null;
var user; 
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

document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const username = urlParams.get('username');

    [user, currentUserData] = await Promise.all([
        fetchJson(`${API_BASE_URL}/user/${username}`),
        fetchJson(`${API_BASE_URL}/user/me`)
    ]);
    document.getElementById('currentUserPage').href = `user.html?username=${encodeURIComponent(currentUserData.username)}`;

    document.getElementById('profileContainer').innerHTML = `<p>Felhasználó nem található.</p>`;
    loadUserProfile(user);
    
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
    
        if(method !== 'DELETE') return response.json();
        return response;
    }catch{
        showAlert('Szerver oldali hiba! Átirányítás a kezdőlapra...','error');
        setTimeout(() =>{
            window.location.href = 'authorisation.html';
        },5000)
    }
}

function loadUserProfile(user) {
    const profileContainer = document.getElementById('profileContainer');

    if (user.username === currentUserData.username) {
        profileContainer.innerHTML = `
            <div class="own-profile profile-header">
                <div>
                    <label for="profileUsername">Felhasználónév:</label>
                    <input type="text" id="profileUsername" value="${user.username}" />
                    <label for="profileBio">Bemutatkozás:</label>
                    <textarea id="profileBio" rows="4">${user.bio}</textarea>
                    <label for="profileEmail">Email:</label>
                    <input type="email" id="profileEmail" value="${user.email}" />
                    <button onclick="saveUserProfile()">Mentés</button>
                    <p id="error-message-bio" style="color: red; display: none;"></p>
                </div>
                <div>                    
                    <div class="upload">
                    <img src="${user.profileImage}" id="profileImageUpload" alt="${user.username}" width="100" height="100">
                    <div class="round">
                        <input type="file" accept="image/*" onchange="uploadProfileImage(this.files[0])">
                        <i class="fa fa-camera" style="color: #fff;"></i>
                    </div>
                    </div>
                </div>
                <div>
                    <h3>Jelszó módosítás</h3>
                    <label for="currentPassword">Jelenlegi jelszó:</label>
                    <div class="password-input-wrapper">
                    <input type="password" id="currentPassword" placeholder="Jelenlegi jelszó">
                    <i class="fas fa-eye toggle-password"></i>
                    </div>

                    <label for="newPassword">Új jelszó:</label>
                    <div class="password-input-wrapper">
                    <input type="password" id="newPassword" placeholder="Új jelszó">
                    <i class="fas fa-eye toggle-password"></i>
                    </div>

                    <label for="confirmNewPassword">Új jelszó megerősítése:</label>
                    <div class="password-input-wrapper">
                    <input type="password" id="confirmNewPassword" placeholder="Új jelszó megerősítése">
                    <i class="fas fa-eye toggle-password"></i>
                    </div>
                    <br>
                    <button onclick="changePassword()">Jelszó módosítása</button>
                    <p id="error-message-password" style="color: red; display: none;"></p>
                </div>
            </div>
            <div class="profile-stats">
                <div class="stat-box"><span id="postCount">0</span> bejegyzés</div>
                <div class="stat-box"><span id="userRank">Újonc</span></div>
                <div class="stat-box"><span id="joinedSince"></span></div>
            </div>
            <div class="user-posts">
                <h3>${user.username} bejegyzései</h3>
                <div id="userPostContainer"></div>
            </div>`;
        document.querySelectorAll('.toggle-password').forEach(icon => {
            icon.addEventListener('click', () => {
            const input = icon.previousElementSibling;
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
            });
        });
        
        const newPw = document.getElementById('newPassword');
        const confirmPw = document.getElementById('confirmNewPassword');
        if (newPw) setupPasswordTooltip(newPw);
        if (confirmPw) setupPasswordTooltip(confirmPw);
  
    } else {
        profileContainer.innerHTML = `
            <div class="profile-header">
                <img class="user-image" src="${user.profileImage}" alt="${user.username}">
                <div>
                    <h2>${user.username}</h2>
                    <p class="profile-bio">${user.bio.replace(/\n/g, '<br>')}</p>
                </div>
            </div>
            <div class="profile-stats">
                <div class="stat-box"><span id="postCount">0</span> bejegyzés</div>
                <div class="stat-box"><span id="userRank">Újonc</span></div>
                <div class="stat-box"><span id="joinedSince"></span></div>

            </div>
            <div class="user-posts">
                <h3>${user.username} bejegyzései</h3>
                <div id="userPostContainer"></div>
            </div>`;
    }

    loadUserPosts(user.id);
}

async function loadUserPosts(userId) {
    const container = document.getElementById('userPostContainer');
    const response = await fetchJson(`${API_BASE_URL}/post/user/${userId}?page=${1}&limit=${postsPerPage}`);
    const joinedDate = new Date(user.createdAt);
    const today = new Date();
    const days = Math.floor((today - joinedDate) / (1000 * 60 * 60 * 24));
    document.getElementById('joinedSince').textContent = `Tag ${days} napja`;

    if (!response.posts || response.posts.length === 0) {
        container.innerHTML = `<p>Nincsenek bejegyzések ehhez a felhasználóhoz.</p>`;
        return;
    }

    totalPosts = response.totalCount;
    postsData = response.posts;

    document.getElementById('postCount').textContent = totalPosts;
    document.getElementById('userRank').textContent = totalPosts >= 40 ? 'Mesterhorgász' : totalPosts >= 21 ? 'Törzstag' : totalPosts >= 11 ? 'Aktív tag' : 'Újonc';

    renderUserPosts(false);

    const loadMoreBtn = document.getElementById('loadMoreBtn');
    if (postsData.length < totalPosts) {
        loadMoreBtn.style.display = 'block';
    } else {
        loadMoreBtn.style.display = 'none';
    }

}

async function loadMoreUserPosts(userId) {
    try {
        currentPage++;
        const response = await fetchJson(`${API_BASE_URL}/post/user/${userId}?page=${currentPage}&limit=${postsPerPage}`);

        if (!response.posts || response.posts.length === 0) {
            document.getElementById('loadMoreBtn').style.display = 'none';
            return;
        }

        totalPosts = response.totalCount;
        postsData = [...postsData, ...response.posts];

        renderUserPosts(true);

         if (postsData.length < totalPosts) {
            document.getElementById('loadMoreBtn').style.display = 'block';
        } else {
            document.getElementById('loadMoreBtn').style.display = 'none';
        }
    } catch{
        showAlert('Hálózati hiba történt!','error')
    }
}

function renderUserPosts(append = false) {
    const container = document.getElementById('userPostContainer');

    if (!append) container.innerHTML = '';

    postsData.forEach(post => {
        if (append && document.getElementById(`post-${post.id}`)) return;

        const postDiv = document.createElement('div');
        postDiv.className = 'post clickable';
        postDiv.id = `post-${post.id}`
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

        postDiv.onclick = () => openUserPostModal(post.id);
        container.appendChild(postDiv);
    });
}

async function openUserPostModal(postId) {
    const post = await fetchJson(`${API_BASE_URL}/post/${postId}`);

    currentPostId = postId;

    const postComments = await fetchJson(`${API_BASE_URL}/comment/${postId}/${currentUserData.id}?page=1&limit=${commentsPerPage}`);

    currentCommentPage = 1;
    allComments = postComments.comments;
    totalComments = postComments.totalCount;

    const modalContent = document.getElementById('modalPostContent');

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

    modalContent.innerHTML = `
    <div class="post-header">
        <img src="${post.profileImage || 'resources/default-profile.png'}" alt="Profilkép" class="profile-picture">
        <div class="user-info">
            <a href="user.html?username=${post.userName}" class="user-link">${encodeURIComponent(post.userName)}</a>
            <div class="post-date">${new Date(post.createdAt).toLocaleString()}</div>
        </div>
    </div>
    <p class="post-content">${post.content}</p>
    ${post.imageUrl ? `<img src="${post.imageUrl}" alt="${post.content}" class="post-image" onclick="openImageModal('${post.imageUrl}','${post.content}')">` : ''}
    <div class="comment-form">
        <textarea id="commentContent" placeholder="Írd ide a hozzászólásodat..." rows="4"></textarea>
        <button onclick="submitComment(${postId})">Hozzászólás küldése</button>
    </div>
    <div class="comments-section">
        <h3>Hozzászólások</h3>
        ${commentsHtml}
    </div>
    <button id="loadMoreCommentsBtn" onclick="loadMoreComments()">Több hozzászólás betöltése</button>`;

    document.getElementById('loadMoreCommentsBtn').style.display = totalComments < 6 ? 'none' : 'block';

    const modal = document.getElementById('userPostModal');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
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
            <div class='comment-header'>
                <img src='${comment.user.profileImage || 'resources/default-profile.png'}' alt='Profilkép' class='profile-picture'>
                <div class='user-info'>
                    <a href='user.html?username=${encodeURIComponent(comment.user.username)}' class='user-link'>${comment.user.username}</a>
                    <div class='comment-date'>${new Date(comment.createdAt).toLocaleString()}</div>
                </div>
            </div>
            <div class='comment-body'>${comment.content}</div>
            <div class="comment-actions">
                <button class="like-btn ${comment.userLike === 'Like' ? 'active-like' : ''}" onclick="likeComment(${comment.id}, 'Like', ${currentPostId})" data-comment-id="${comment.id}" data-like-type="like">👍 ${comment.likes}</button>
                <button class="like-btn ${comment.userLike === 'DisLike' ? 'active-dislike' : ''}" onclick="likeComment(${comment.id}, 'DisLike', ${currentPostId})" data-comment-id="${comment.id}" data-like-type="dislike">👎 ${comment.disLikes}</button>
            </div>`;
        commentsSection.appendChild(commentDiv);
    });


    document.getElementById('loadMoreCommentsBtn').style.display = allComments.length < totalComments ? 'block' : 'none';
}

function closeModal() {
    document.getElementById('userPostModal').style.display = 'none';
    document.body.style.overflow = '';
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

        document.getElementById('commentContent').value = '';
        openUserPostModal(postId);
    } catch{
        showAlert('Hálózati hiba történt!',);
    }
}

document.getElementById('userPostModal').addEventListener('click', (event) => {
    if (event.target.id === 'userPostModal') {
        closeModal();
    }
});

function saveUserProfile() {
    const username = document.getElementById('profileUsername').value.trim();
    const bio = document.getElementById('profileBio').value.trim();
    const email = document.getElementById('profileEmail').value.trim();
    const errorMessage = document.getElementById('error-message-bio');

    if (username.length < 5) {
        errorMessage.textContent = 'A felhasználónévnek legalább 5 karakter hosszúnak kell lennie!';
        errorMessage.style.display = 'block';
        return;
    }

    if (!isValidEmail(email)) {
        errorMessage.textContent = 'Érvényes email címet adj meg!';
        errorMessage.style.display = 'block';
        return;
    }

    const updatedUser = {
        ...currentUserData,
        username,
        bio,
        email
    };

    fetch(`${API_BASE_URL}/user/${currentUserData.id}`, {
        method: 'PUT',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedUser)
    })
    .then(response => {
        if (!response.ok) return response.json().then(err => { throw new Error(err.message); });
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showAlert('Profil frissítése sikeres!','success');
            errorMessage.style.display = 'none';
        } else {
            errorMessage.textContent = data.message || 'Hiba történt a profil frissítése során.';
            errorMessage.style.display = 'block';
        }
    })
    .catch(error => {
        errorMessage.textContent = error.message;
        errorMessage.style.display = 'block';
    });
}

function isValidEmail(email) {
    var regex = /^(([^<>()\[\]\\.,;:\s@']+(\.[^<>()\[\]\\.,;:\s@']+)*)|('.+'))@(([^<>()[\]\\.,;:\s@']+\.)+[^<>()[\]\\.,;:\s@']{2,})$/i;
    return regex.test(String(email).toLowerCase());
}

function changePassword() {
    const currentPassword = document.getElementById('currentPassword').value.trim();
    const newPassword = document.getElementById('newPassword').value.trim();
    const confirmNewPassword = document.getElementById('confirmNewPassword').value.trim();
    var errorMessage = document.getElementById('error-message-password');

    if (!currentPassword || !newPassword || !confirmNewPassword) {
        showAlert('Kérlek tölts ki minden mezőt!','error');
        return;
    }

    if (!isValidPassword(newPassword)) {
        errorMessage.style.display = 'block';
        errorMessage.textContent = 'Az új jelszó nem felel meg a meghatározott formátumnak!';
        return;
    }

    if (newPassword !== confirmNewPassword) {
        errorMessage.style.display = 'block';
        errorMessage.textContent = 'Az új jelszók nem egyeznek meg!';
        return;
    }

    const passwordData = {
        currentPassword,
        newPassword,
        confirmNewPassword
    };


    fetch(`${API_BASE_URL}/user/${currentUserData.username}/changePassword`, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(passwordData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert('Jelszó sikeresen módosítva.','success');
            errorMessage.style.display = 'none';
            document.getElementById('currentPassword').value = '';
            document.getElementById('newPassword').value = '';
            document.getElementById('confirmNewPassword').value = '';
        } else if (data.message === 'A jelenlegi jelszó nem megfelelő.') {
            errorMessage.style.display = 'block';
            errorMessage.textContent = 'A jelenlegi jelszó nem megfelelő.';
        } else if (data.message === 'Az új jelszavak nem egyeznek meg.') {
            errorMessage.style.display = 'block';
            errorMessage.textContent = 'Az új jelszavak nem egyeznek meg.';
        } else {
            showAlert('Hiba történt a jelszó módosítása során!','error');
        }
    })    
    .catch(showAlert('Hiba a jelszó módosítása során!','error'));
}

async function uploadProfileImage(file) {
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (event) {
        const img = new Image();
        img.onload = function () {
            const canvas = document.createElement('canvas');
            const maxSize = 200;
            var width = img.width;
            var height = img.height;
            const ratio = Math.min(maxSize / width, maxSize / height);
            width *= ratio;
            height *= ratio;
            canvas.width = width;
            canvas.height = height;

            const ctx = canvas.getContext('2d');
            ctx.drawImage(img, 0, 0, width, height);

            canvas.toBlob(async function (blob) {
                const formData = new FormData();
                formData.append('profile_picture', blob, 'compressed.jpg');
                formData.append('username', currentUserData.username);

                const response = await fetch('/frontend/upload_pfp.php', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                if (response.ok) {
                    showAlert('Profilkép sikeresen feltöltve!', 'success');
                    document.getElementById('profileImageUpload').src = result.profileImage + '?t=' + new Date().getTime();
                } else {
                    showAlert('Hiba a feltöltés közben!', 'error');
                }
            }, 'image/jpeg', 0.75);
        };
        img.src = event.target.result;
    };
    reader.readAsDataURL(file);
}

  
  function setupPasswordTooltip(input) {
    const tooltip = document.createElement('div');
    tooltip.className = 'password-tooltip';
    tooltip.innerHTML = `
      <ul>
          <li data-check='length'>Legalább 8 karakter</li>
          <li data-check='lower'>Kisbetű</li>
          <li data-check='upper'>Nagybetű</li>
          <li data-check='number'>Szám</li>
      </ul>`;
    document.body.appendChild(tooltip);
  
    const updateTooltipPosition = () => {
      const rect = input.getBoundingClientRect();
      tooltip.style.top = window.scrollY + rect.bottom + 6 + 'px';
      tooltip.style.left = window.scrollX + rect.left + 'px';
    };
  
    const updateTooltipContent = () => {
      const value = input.value;
      const checks = {
        length: value.length >= 8,
        lower: /[a-z]/.test(value),
        upper: /[A-Z]/.test(value),
        number: /\d/.test(value),
      };
  
      Object.entries(checks).forEach(([key, passed]) => {
        const li = tooltip.querySelector(`li[data-check='${key}']`);
        if (li) li.classList.toggle('valid', passed);
      });
    };
  
    input.addEventListener('focus', () => {
      tooltip.style.display = 'block';
      updateTooltipPosition();
    });
  
    input.addEventListener('blur', () => {
      tooltip.style.display = 'none';
    });
  
    input.addEventListener('input', () => {
      updateTooltipContent();
      updateTooltipPosition();
    });
  
    window.addEventListener('scroll', updateTooltipPosition);
    window.addEventListener('resize', updateTooltipPosition);
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

function isValidPassword(password) {
    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
    return regex.test(password);
}

async function deletePost(postId) {
    if (!confirm('Biztosan törölni szeretnéd ezt a posztot?')) return;

    try {
        await fetchJson(`${API_BASE_URL}/post/${postId}`, 'DELETE');
        showAlert('A poszt törölve lett!', 'success');

        currentPage = 1;
        const response = await fetchJson(`${API_BASE_URL}/post/user/${user.id}?page=${currentPage}&limit=${postsPerPage}`);
        
        postsData = response.posts;
        totalPosts = response.totalCount;
        document.getElementById('postCount').textContent = totalPosts;

        if (totalPosts === 0) {
            document.getElementById('userPostContainer').innerHTML = `<p>Nincsenek bejegyzések ehhez a felhasználóhoz.</p>`;
        } else {
            renderUserPosts(false);
        }

    } catch (error) {
        showAlert('Nem sikerült törölni a posztot!', 'error');
    }
}