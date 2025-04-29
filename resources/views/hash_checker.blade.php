<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bcrypt Hash Checker</title>
</head>
<body>
    <h1>Bcrypt Hash Checker</h1>

    <form method="POST" action="{{ route('hash.check') }}">
        @csrf
        <div>
            <label>Password:</label>
            <input type="text" name="password" required>
        </div>

        <div>
            <label>Bcrypt Hash:</label>
            <input type="text" name="hash" required>
        </div>

        <button type="submit">Check</button>
    </form>

    @if (session('result'))
        <h2>Result: {{ session('result') }}</h2>
    @endif
</body>
</html>
