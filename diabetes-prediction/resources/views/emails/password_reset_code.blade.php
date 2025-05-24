<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reset Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            text-align: center;
            border-radius: 5px 5px 0 0;
        }
        .content {
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 0 0 5px 5px;
        }
        .reset-code {
            background-color: #fff;
            border: 2px solid #4CAF50;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            margin: 20px 0;
        }
        .reset-code h2 {
            margin: 0;
            font-size: 36px;
            color: #4CAF50;
            letter-spacing: 5px;
        }
        .warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 5px;
            padding: 15px;
            margin: 20px 0;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Reset Password</h1>
    </div>
    
    <div class="content">
        <p>Halo <strong>{{ $name }}</strong>,</p>
        
        <p>Kami menerima permintaan untuk reset password akun Anda. Gunakan kode verifikasi berikut untuk melanjutkan proses reset password:</p>
        
        <div class="reset-code">
            <h2>{{ $resetCode }}</h2>
        </div>
        
        <div class="warning">
            <strong>⚠️ Penting:</strong>
            <ul>
                <li>Kode ini berlaku selama <strong>15 menit</strong></li>
                <li>Jangan bagikan kode ini kepada siapapun</li>
                <li>Jika Anda tidak meminta reset password, abaikan email ini</li>
            </ul>
        </div>
        
        <p>Masukkan kode tersebut di aplikasi untuk melanjutkan proses reset password.</p>
        
        <p>Terima kasih,<br>
        Tim Aplikasi Kesehatan</p>
    </div>
    
    <div class="footer">
        <p>Email ini dikirim otomatis, mohon tidak membalas email ini.</p>
    </div>
</body>
</html>