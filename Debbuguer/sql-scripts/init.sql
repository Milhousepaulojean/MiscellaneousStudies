USE mydatabase;

CREATE TABLE IF NOT EXISTS helloworld (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255) NOT NULL
);

INSERT INTO helloworld (message) VALUES ('Hello, World!');
