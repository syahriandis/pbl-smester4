<!DOCTYPE html>
<html>
<head>
    <title>Login Admin Diabetes</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1b5e20, #66bb6a);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            width: 380px;
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            margin-bottom: 5px;
            color: #1b4332;
        }

        p {
            text-align: center;
            color: #4b5563;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            color: #1b4332;
        }

        input {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
            margin-bottom: 18px;
            border: 1px solid #a5d6a7;
            border-radius: 8px;
            box-sizing: border-box;
        }

        input:focus {
            outline: none;
            border-color: #2e7d32;
            box-shadow: 0 0 0 2px rgba(46, 125, 50, 0.2);
        }

        button {
            width: 100%;
            padding: 12px;
            border: none;
            background: #2e7d32;
            color: white;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background: #1b5e20;
        }

        .error {
            background: #ffebee;
            color: #c62828;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
            text-align: center;
        }

        .footer {
            margin-top: 15px;
            font-size: 13px;
            text-align: center;
            color: #4b5563;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Admin Diabetes App</h2>
    <p>Login untuk masuk dashboard admin</p>

    @if(session('error'))
        <div class="error">{{ session('error') }}</div>
    @endif

    <form method="POST" action="/admin/login">
        @csrf

        <label>Email</label>
        <input type="email" name="email" placeholder="Email" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Login</button>
    </form>

    <div class="footer">
        Aplikasi Rekomendasi Menu Diabetes
    </div>
</div>

</body>
</html>