class Pokemon
    attr_accessor :id, :name, :type, :db

    def initialize(id:, name:, type:, db:)
        @db = db
        @id = id
        @name = name
        @type = type 
    end 

    def self.save(name, type, db)
        sql =<<-SQL
        INSERT INTO pokemon (name, type) VALUES (?, ?)
        SQL

        db.execute(sql, name, type)
        @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
    end 

    def self.new_from_db(row)
        new_pokemon = self.new(id: row[0],name: row[1],type: row[2],db: row[3])
        new_pokemon.id = row[0]
        new_pokemon.name = row[1]
        new_pokemon.type = row[2]
        new_pokemon.db = row[3]
        new_pokemon
    end 

    def self.find(id, db)
        sql =<<-SQL
        SELECT *
        FROM pokemon
        WHERE id = ?        
        SQL

        db.execute(sql, id).map {|row| self.new_from_db(row)}.first
    end

end
