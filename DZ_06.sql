-- 1.	Решение задачи с использованием функции:

CREATE FUNCTION delete_user(id_to_delete BIGINT UNSIGNED) 
RETURNS BIGINT UNSIGNED
BEGIN
    DECLARE user_id BIGINT UNSIGNED;
    START TRANSACTION;

    -- Удаляем сообщения пользователя
    DELETE FROM messages WHERE from_user_id = id_to_delete OR to_user_id = id_to_delete;

    -- Удаляем лайки пользователя
    DELETE FROM likes WHERE user_id = id_to_delete;

    -- Удаляем медиа записи пользователя
    DELETE FROM media WHERE user_id = id_to_delete;

    -- Удаляем профиль пользователя
    DELETE FROM profiles WHERE user_id = id_to_delete;

    -- Удаляем запись о пользователе из таблицы users и сохраняем его id
    SELECT id INTO user_id FROM users WHERE id = id_to_delete;
    DELETE FROM users WHERE id = id_to_delete;

    COMMIT;
    RETURN user_id;


/* В данном решении мы используем функцию delete_user, которая принимает в качестве аргумента id_to_delete - id пользователя, которого необходимо удалить.
Внутри функции мы используем транзакцию для гарантии целостности данных. Затем, последовательно удаляем все связанные с пользователем данные: сообщения, лайки, медиа записи и профиль. В конце удаляем запись о пользователе из таблицы users и сохраняем его id в переменную user_id.
Функция возвращает id удаленного пользователя. */


-- 2.	Решение задачи с использованием процедуры:
CREATE PROCEDURE delete_user_procedure(id_to_delete BIGINT UNSIGNED)
BEGIN
    DECLARE user_id BIGINT UNSIGNED;
    START TRANSACTION;

    -- Удаляем сообщения пользователя
    DELETE FROM messages WHERE from_user_id = id_to_delete OR to_user_id = id_to_delete;

    -- Удаляем лайки пользователя
    DELETE FROM likes WHERE user_id = id_to_delete;

    -- Удаляем медиа записи пользователя
    DELETE FROM media WHERE user_id = id_to_delete;

    -- Удаляем профиль пользователя
    DELETE FROM profiles WHERE user_id = id_to_delete;

    -- Удаляем запись о пользователе из таблицы users и сохраняем его id
    SELECT id INTO user_id FROM users WHERE id = id_to_delete;
    DELETE FROM users WHERE id = id_to_delete;

    COMMIT;

/* В данном решении мы используем процедуру delete_user_procedure, которая принимает в качестве аргумента id_to_delete - id пользователя, которого необходимо удалить. */

/* Внутри процедуры мы используем транзакцию для гарантии целостности данных. Затем, последовательно удаляем все связанные с пользователем данные: сообщения, лайки, медиа записи и профиль. В конце удаляем запись о пользователе из таблицы users.
Важно отметить, что команды для удаления данных уже сами по себе являются транзакционными, но в данном решении мы обернули используемые команды в транзакцию внутри процедуры, чтобы быть уверенными в том, что все изменения будут выполнены либо не выполнены вместе. */


-- Вот пример процедуры, которая удаляет все данные о пользователе с заданным id:
CREATE PROCEDURE delete_user(IN p_user_id BIGINT UNSIGNED)
BEGIN
    START TRANSACTION;
    DELETE FROM likes WHERE user_id = p_user_id;
    DELETE FROM messages WHERE from_user_id = p_user_id OR to_user_id = p_user_id;
    DELETE FROM media WHERE user_id = p_user_id;
    DELETE FROM profiles WHERE user_id = p_user_id;
    DELETE FROM friend_requests WHERE initiator_user_id = p_user_id OR target_user_id = p_user_id;
    DELETE FROM users_communities WHERE user_id = p_user_id;
    DELETE FROM users WHERE id = p_user_id;
    COMMIT;

/* Здесь мы создали процедуру с именем delete_user, которая принимает в качестве аргумента id пользователя, который должен быть удален. В теле процедуры мы начинаем транзакцию с помощью команды START TRANSACTION, затем удаляем все данные о пользователе из таблиц likes, messages, media, profiles, friend_requests, users_communities и users. В конце мы подтверждаем транзакцию с помощью команды COMMIT. */

-- Чтобы вызвать эту процедуру, нужно использовать команду CALL следующим образом:
CALL delete_user(100);

/* Здесь мы вызываем процедуру delete_user с аргументом 100, чтобы удалить пользователя с id 100. */
