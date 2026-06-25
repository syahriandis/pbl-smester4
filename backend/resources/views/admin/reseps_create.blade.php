<!DOCTYPE html>
<html>

<head>
    <title>Tambah Resep</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f1f8e9;
        }

        .sidebar {
            width: 250px;
            height: 100vh;
            background: #2e7d32;
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            padding: 20px;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .sidebar a:hover,
        .sidebar .active {
            background: #1b5e20;
        }

        .logout {
            margin-top: 30px;
            background: #c62828;
            text-align: center;
        }

        .logout:hover {
            background: #b71c1c;
        }

        .content {
            margin-left: 250px;
            padding: 30px;
        }

        .header,
        .form-box {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 3px 10px rgba(0,0,0,.1);
            margin-bottom: 25px;
        }

        .header h1 {
            color: #2e7d32;
        }

        .header p {
            color: #666;
            margin-top: 8px;
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 8px;
            font-weight: bold;
            color: #2e7d32;
        }

        input,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
        }

        textarea {
            resize: vertical;
        }

        input:focus,
        textarea:focus {
            border-color: #2e7d32;
            outline: none;
            box-shadow: 0 0 5px rgba(46,125,50,.3);
        }

        .btn {
            margin-top: 25px;
            background: #2e7d32;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
        }

        .btn:hover {
            background: #1b5e20;
        }

        .btn-back {
            display: inline-block;
            margin-bottom: 20px;
            text-decoration: none;
            color: white;
            background: #757575;
            padding: 10px 16px;
            border-radius: 8px;
        }

        .btn-back:hover {
            background: #616161;
        }

    </style>

</head>

<body>

<div class="sidebar">

    <h2>🌿 Diabetes Admin</h2>

    <a href="/admin/dashboard">🏠 Beranda</a>
    <a href="/admin/pengguna">👤 Data Pengguna</a>
    <a href="/admin/gula-darah">📊 Data Gula Darah</a>
    <a href="/admin/food-items">🥤 Makanan Dan Minuman</a>
    <a href="/admin/reseps" class="active">🍳 Resep</a>

    <a href="/admin/logout" class="logout">🚪 Logout</a>

</div>

<div class="content">

    <div class="header">
        <h1>Tambah Resep</h1>
        <p>Tambahkan resep makanan sehat baru ke dalam aplikasi.</p>
    </div>

    <div class="form-box">

        <a href="/admin/reseps" class="btn-back">
            ← Kembali
        </a>

        <form action="/admin/reseps" method="POST" enctype="multipart/form-data">

            @csrf

            <label>Nama Resep</label>

            <input
                type="text"
                name="nama"
                placeholder="Masukkan nama resep"
                required>

            <label>Gambar Resep</label>

            <input
                type="file"
                name="gambar"
                accept="image/*">

            <label>Komposisi</label>

            <textarea
                name="komposisi"
                rows="6"
                placeholder="Masukkan komposisi resep..."
                required></textarea>

            <label>Cara Memasak</label>

            <textarea
                name="cara"
                rows="8"
                placeholder="Masukkan langkah-langkah memasak..."
                required></textarea>

            <button type="submit" class="btn">
                💾 Simpan Resep
            </button>

        </form>

    </div>

</div>

</body>

</html>