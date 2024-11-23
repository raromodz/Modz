const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Usuários fictícios para autenticação
const users = {
    'usuario1': 'senha1',
    'usuario2': 'senha2',
};

// Rota para verificar o login
app.post('/login', (req, res) => {
    const { username, password } = req.body;

    if (users[username] && users[username] === password) {
        return res.status(200).json({ message: 'Login bem-sucedido!' });
    } else {
        return res.status(401).json({ message: 'Usuário ou senha incorretos!' });
    }
});

// Iniciar o servidor
app.listen(PORT, () => {
    console.log(`Servidor rodando em http://localhost:${PORT}`);
});
