extends Node

# TODO: Класс сессии клиента.
# Отвечает за гарантию неразрывности единственности соединения под одним аккаунтом

# Пока только для сервера игровой сессии, но потом и для "гейтвея/сервера аутентификации"
# (надо как-то сделать одновременную выдачу только одного токена на один сервер
# но при этом, чтобы пользователь мог передумать или отвалиться с соединением
# и получить токен на другой сервер)
# (ВОЗМОЖНО БУДЕТ) Хранит токен доступа конкретного игрока на игровой сервер
