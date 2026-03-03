const express = require('express');
const app = express();
const path = require('path');
app.use(express.static(path.join(__dirname, 'build', 'web')));
app.get('*', function (req, res) {
  res.sendFile(path.join(__dirname, 'build', 'web', 'index.html'));
});
app.listen(8080, () => {
  console.log('App listening on port 8080');
});
