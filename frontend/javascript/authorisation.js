localStorage.clear();

document.addEventListener("DOMContentLoaded", () => {
    const showRegister = document.getElementById("showRegister");
    const showLogin = document.getElementById("showLogin");
    const loginForm = document.getElementById("login");
    const registerForm = document.getElementById("register");

    showRegister.addEventListener("click", (e) => {
      e.preventDefault();
      loginForm.classList.remove("active");
      registerForm.classList.add("active");
    });

    showLogin.addEventListener("click", (e) => {
      e.preventDefault();
      registerForm.classList.remove("active");
      loginForm.classList.add("active");
    });
  });

const signUpButton = document.getElementById('signUp');
const signInButton = document.getElementById('signIn');
const container = document.getElementById('container');

if (signUpButton && signInButton && container) {
    signUpButton.addEventListener('click', () => {
        container.classList.add('right-panel-active');
    });

    signInButton.addEventListener('click', () => {
        container.classList.remove('right-panel-active');
    });
}

const signUpForm = document.querySelector('.sign-up-container form');
const signInForm = document.querySelector('.sign-in-container form');

if (signUpForm && signInForm) {
    signUpForm.addEventListener('submit', async (event) => {
        event.preventDefault();
    
        const formData = new FormData(signUpForm);
        const userName = formData.get('RegUsername').trim();
        const email = formData.get('RegEmail').trim();
        const password = formData.get('RegPassword').trim();
        const confirmPassword = formData.get('RegPasswordConfirm').trim();
    
        if (userName.length < 5) {
            showError(signUpForm, 'A felhasználónévnek legalább 5 karakter hosszúnak kell lennie.');
            return;
        }
        
        if(!isValidEmail(email)){
            showError(signUpForm, 'Nem megfelelő az email formátuma!');
            return;
        }

        if (password !== confirmPassword) {
            showError(signUpForm, 'A megadott jelszavak nem egyeznek.');
            return;
        }
    
        if (!isValidPassword(password)) {
            showError(signUpForm, 'A jelszónak legalább 8 karakter hosszúnak kell lennie, és tartalmaznia kell kis- és nagybetűt, valamint számot.');
            return;
        }
    
        const user = {
            username: userName,
            email: email,
            password: password
        };
    
        const response = await fetch('http://localhost:61227/api/user/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(user)
        });
    
        if (response.ok) {
            const data = await response.json();
            localStorage.setItem('token', data);
            window.location.href = 'shop.html';
        } else if (response.status === 409) {
            showError(signUpForm, 'Ez a felhasználónév vagy email már foglalt.');
        } else if (response.status === 400) {
            const msg = await response.text();
            showError(signUpForm, msg || 'Hibás adatok, kérlek ellenőrizd a mezőket.');
        } else {
            showError(signUpForm, 'Ismeretlen hiba a regisztráció során.');
        }
    });
    
    

    signInForm.addEventListener('submit', async (event) => {
        event.preventDefault();
    
        const formData = new FormData(signInForm);
        const loginData = {
            usernameoremail: formData.get('LogEmailOrUsername'),
            password: formData.get('LogPassword')
        };
    
        const response = await fetch('http://localhost:61227/api/user/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(loginData)
        });
    
        if (response.ok) {
            const data = await response.json();
            localStorage.setItem('token', data);
            window.location.href = 'shop.html';
        } else if (response.status === 404) {
            showError(signInForm, 'Felhasználó nem található.');
        } else if (response.status === 401) {
            showError(signInForm, 'Hibás jelszó.');
        } else if (response.status === 400) {
            const msg = await response.text();
            showError(signInForm, msg || 'Hibás adatok, kérlek töltsd ki a mezőket.');
        } else {
            showError(signInForm, 'Ismeretlen hiba történt a bejelentkezés során.');
        }
    });
    
}

const mobileLoginForm = document.querySelector('#login form');
const mobileRegisterForm = document.querySelector('#register form');

if (mobileRegisterForm) {
    mobileRegisterForm.addEventListener('submit', async (event) => {
        event.preventDefault();
    
        const formData = new FormData(mobileRegisterForm);
        const userName = formData.get('RegUsername').trim();
        const email = formData.get('RegEmail').trim();
        const password = formData.get('RegPassword').trim();
        const confirmPassword = formData.get('RegPasswordConfirm').trim();
    
        if (userName.length < 5) {
            showError(signUpForm, 'A felhasználónévnek legalább 5 karakter hosszúnak kell lennie.');
            return;
        }
        
        if(!isValidEmail(email)){
            showError(mobileRegisterForm, 'Nem megfelelő az email formátuma!');
            return;
        }

        if (password !== confirmPassword) {
            showError(mobileRegisterForm, 'A megadott jelszavak nem egyeznek.');
            return;
        }
    
        if (!isValidPassword(password)) {
            showError(mobileRegisterForm, 'A jelszónak legalább 8 karakter hosszúnak kell lennie, és tartalmaznia kell kis- és nagybetűt, valamint számot.');
            return;
        }
    
        const user = {
            username: userName,
            email: email,
            password: password
        };
    
        const response = await fetch('http://localhost:61227/api/user/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(user)
        });
    
        if (response.ok) {
            const data = await response.json();
            localStorage.setItem('token', data);
            window.location.href = 'shop.html';
        } else if (response.status === 409) {
            showError(mobileRegisterForm, 'Ez a felhasználónév vagy email már foglalt.');
        } else if (response.status === 400) {
            const msg = await response.text();
            showError(mobileRegisterForm, msg || 'Hibás adatok, kérlek ellenőrizd a mezőket.');
        } else {
            showError(mobileRegisterForm, 'Ismeretlen hiba a regisztráció során.');
        }
    });
}

if (mobileLoginForm) {
    mobileLoginForm.addEventListener('submit', async (event) => {
        event.preventDefault();
    
        const formData = new FormData(mobileLoginForm);
        const loginData = {
            usernameoremail: formData.get('LogEmailOrUsername'),
            password: formData.get('LogPassword')
        };
    
        const response = await fetch('http://localhost:61227/api/user/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(loginData)
        });
    
        if (response.ok) {
            const data = await response.json();
            localStorage.setItem('token', data);
            window.location.href = 'shop.html';
        } else if (response.status === 404) {
            showError(mobileLoginForm, 'Felhasználó nem található.');
        } else if (response.status === 401) {
            showError(mobileLoginForm, 'Hibás jelszó.');
        } else if (response.status === 400) {
            const msg = await response.text();
            showError(mobileLoginForm, msg || 'Hibás adatok, kérlek töltsd ki a mezőket.');
        } else {
            showError(mobileLoginForm, 'Ismeretlen hiba történt a bejelentkezés során.');
        }
    });
}

function showError(form, message) {
    var errorDiv = form.querySelector('.form-error');
    if (!errorDiv) {
        errorDiv = document.createElement('div');
        errorDiv.className = 'form-error';
        errorDiv.style.color = 'red';
        errorDiv.style.marginBottom = '10px';
        form.prepend(errorDiv);
    }
    errorDiv.textContent = message;
}

function isValidEmail(email) {
    var regex = /^(([^<>()\[\]\\.,;:\s@']+(\.[^<>()\[\]\\.,;:\s@']+)*)|('.+'))@(([^<>()[\]\\.,;:\s@']+\.)+[^<>()[\]\\.,;:\s@']{2,})$/i;
    return regex.test(String(email).toLowerCase());
}

function isValidPassword(password) {
    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
    return regex.test(password);
}

function setupPasswordTooltip(input) {
    const tooltip = document.createElement('div');
    tooltip.className = 'password-tooltip';
    tooltip.innerHTML = `
        <ul>
            <li data-check="length">Legalább 8 karakter</li>
            <li data-check="lower">Kisbetű</li>
            <li data-check="upper">Nagybetű</li>
            <li data-check="number">Szám</li>
        </ul>
    `;
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
            const li = tooltip.querySelector(`li[data-check="${key}"]`);
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

document.querySelectorAll('input[name="RegPassword"], input[name="RegPasswordConfirm"]').forEach(input => {
    setupPasswordTooltip(input);
});

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