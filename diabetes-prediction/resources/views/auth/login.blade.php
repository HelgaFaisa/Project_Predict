<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediCare Diabetes Portal | Admin Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Montserrat', 'Helvetica Neue', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #344767;
        }
        
        .login-container {
            display: flex;
            width: 900px;
            height: 550px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
            border-radius: 16px;
            overflow: hidden;
        }
        
        .login-image {
            flex: 1;
            background: linear-gradient(135deg, rgba(41, 128, 185, 0.9), rgba(52, 152, 219, 0.8)), url('/api/placeholder/600/550') center center no-repeat;
            background-size: cover;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 40px;
            color: white;
        }
        
        .login-image h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .login-image p {
            font-size: 16px;
            opacity: 0.9;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .login-form {
            flex: 1;
            background: white;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .logo {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .logo i {
            font-size: 28px;
            color: #3498db;
            margin-right: 10px;
        }
        
        .logo span {
            font-size: 24px;
            font-weight: 700;
            color: #344767;
        }
        
        .welcome-text {
            margin-bottom: 30px;
        }
        
        .welcome-text h2 {
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .welcome-text p {
            color: #718096;
            font-size: 15px;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .input-icon {
            position: relative;
        }
        
        .input-icon i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #8898aa;
        }
        
        .form-control {
            width: 100%;
            padding: 14px 16px 14px 45px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
            background-color: white;
        }
        
        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #8898aa;
            cursor: pointer;
        }
        
        .error-container {
            background-color: #feedec;
            border-left: 4px solid #e53e3e;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 25px;
        }
        
        .error-container ul {
            margin-left: 20px;
            color: #e53e3e;
        }
        
        .submit-btn {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 4px 10px rgba(52, 152, 219, 0.2);
        }
        
        .submit-btn:hover {
            background: linear-gradient(135deg, #2980b9, #2573a7);
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.3);
            transform: translateY(-2px);
        }
        
        .forgot-password {
            text-align: right;
            margin-top: 10px;
        }
        
        .forgot-password a {
            color: #3498db;
            font-size: 14px;
            text-decoration: none;
            font-weight: 500;
        }
        
        .forgot-password a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .login-container {
                width: 95%;
                flex-direction: column;
                height: auto;
            }
            
            .login-image {
                display: none;
            }
            
            .login-form {
                padding: 30px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-image">
            <h1>MediCare Diabetes Portal</h1>
            <p>Advanced healthcare management platform for monitoring patient progress and treatment plans efficiently.</p>
        </div>
        <div class="login-form">
            <div class="logo">
                <i class="fas fa-heartbeat"></i>
                <span>MediCare</span>
            </div>
            
            <div class="welcome-text">
                <h2>Welcome back</h2>
                <p>Please enter your credentials to access the admin portal</p>
            </div>
            
            @if ($errors->any())
            <div class="error-container">
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
            @endif
            
            <form method="POST" action="{{ url('/login') }}">
                @csrf
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" class="form-control" placeholder="doctor@example.com" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                        <span class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-sign-in-alt"></i> Login to Dashboard
                </button>
                
                <div class="forgot-password">
                    <a href="#">Forgot password?</a>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const icon = document.querySelector('.password-toggle i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
    </script>
</body>
</html>