const express = require('express');
const app = express();

app.all('/*', (req, res) => { 
    response = {
        body: req.body,
        headers: req.headers,
        method: req.method,
        url: req.originalUrl
    };
    res.send(response);
});

app.listen(8080);
