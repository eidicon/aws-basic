CREATE DATABASE AWS_COURSE_DB;

CREATE TABLE cloud_providers (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO cloud_providers VALUES(1, 'aws');
INSERT INTO cloud_providers VALUES(2, 'azure');
INSERT INTO cloud_providers VALUES(3, 'gcp');

SELECT * FROM cloud_providers;