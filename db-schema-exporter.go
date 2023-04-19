package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/go-sql-driver/mysql"
	"github.com/robfig/cron"
)

func main() {
	c := cron.New()

	err := c.AddFunc(os.Getenv("CRON_SPEC"), func() {
		er := exportDBSchema(os.Getenv("EXPORT_FILE_PATH"),
			os.Getenv("DB_USER"), os.Getenv("DB_PASSWORD"),
			os.Getenv("DB_HOST"), os.Getenv("DB_NAME"))
		if er != nil {
			log.Printf("Error exporting schema: %v\n", er)
		}
	})

	if err != nil {
		log.Printf("Error setting cron job: %v\n", err)
		return
	}

	c.Start()

	log.Println("Cron job started")

	select {}
}

func exportDBSchema(exportFilePath string,
	dbUser string, dbPassword string, dbHost string, dbName string) error {
	mysqlCfg := mysql.Config{
		User:                 dbUser,
		Passwd:               dbPassword,
		Net:                  "tcp",
		Addr:                 dbHost,
		DBName:               dbName,
		AllowNativePasswords: true,
	}
	db, err := sql.Open("mysql", mysqlCfg.FormatDSN())
	if err != nil {
		return fmt.Errorf("Error connecting to database: %v", err)
	}
	defer db.Close()

	now := time.Now()
	fileName := fmt.Sprintf("%d-%02d-%02d_%02d-%02d-%02d.sql",
		now.Year(), now.Month(), now.Day(), now.Hour(), now.Minute(), now.Second())
	filePath := fmt.Sprintf("%s/%s", exportFilePath, fileName)

	log.Printf("Exporting schema to %s\n", filePath)

	output, err := os.Create(filePath)
	if err != nil {
		return fmt.Errorf("Error creating file: %v", err)
	}
	defer output.Close()

	rows, err := db.Query("SHOW TABLES")
	if err != nil {
		return fmt.Errorf("Error querying database: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var tableName string
		err := rows.Scan(&tableName)
		if err != nil {
			return fmt.Errorf("Error scanning rows: %v", err)
		}

		_, err = output.WriteString(fmt.Sprintf("/* Dumping table %s */\n", tableName))
		if err != nil {
			return fmt.Errorf("Error writing to file: %v", err)
		}

		err = exportTable(db, tableName, output)
		if err != nil {
			return fmt.Errorf("Error exporting table %s: %v", tableName, err)
		}
	}

	return nil
}

func exportTable(db *sql.DB, tableName string, output *os.File) error {
	rows, err := db.Query(fmt.Sprintf("SHOW CREATE TABLE %s", tableName))
	if err != nil {
		return err
	}
	defer rows.Close()

	for rows.Next() {
		var tableName string
		var ddl string
		err := rows.Scan(&tableName, &ddl)
		if err != nil {
			return err
		}
		_, err = output.WriteString(fmt.Sprintf("%s;\n", ddl))
		if err != nil {
			return err
		}
	}

	return nil
}
