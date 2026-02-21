const http = require('http');

http.get('http://localhost:3000/books', (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
        try {
            const books = JSON.parse(data);
            console.log('Book 0 keys:', Object.keys(books[0]));
            console.log('Book 0 Stock:', books[0].available_stock);
            console.log('Book 0 Rating:', books[0].average_rating);
        } catch (e) {
            console.log("Response not JSON:", data.substring(0, 100));
        }
    });
}).on('error', (err) => {
    console.log('Error: ' + err.message);
});
