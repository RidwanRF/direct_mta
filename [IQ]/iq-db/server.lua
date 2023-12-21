local connection;

function connectWithDatabase()
    connection = dbConnect('mysql', 'dbname=db_95799;host=sql.23.svpj.link;charset=utf8', 'db_95799', 'cEGI5wPSwFBv', 'share=1')
    print(connection and 
        'Successfully connected with database' or
        'Failed to connect with database'
    )
end

function status()
    return not not connection
end

function query(...)
    local q = dbQuery(connection, ...)
    return dbPoll(q, 10000)
end


addEventHandler('onResourceStart', resourceRoot, connectWithDatabase)