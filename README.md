# JavaDatabasePractice

<2025-09-23>
CREATE TABLE board (
    no NUMBER(3),
    author VARCHAR(20),
    title VARCHAR2(30),
    content VARCHAR2(100),
    create_at DATE,
    CONSTRAINT board_no_pk PRIMARY KEY(no)
);

CREATE SEQUENCE board_no_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
