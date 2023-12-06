package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	// ghostUser := user.User{
	// 	Id:         0,
	// 	Email:      "jordan@example.com",
	// 	Username:   "ghost",
	// 	Name:       "Michael",
	// 	Lastname:   "Jordan",
	// 	AvatarPath: "https://upload.wikimedia.org/wikipedia/commons/4/44/Black_tea_pot_cropped.jpg",
	// }

	db, err := sql.Open("mysql", os.Getenv("DB_CONNECTION"))
	if err != nil {
		log.Fatalf("[main] database connection error: %v", err.Error())
	}
	db.SetConnMaxLifetime(time.Minute)

	var (
		id       int
		username string
		password string
	)

	row := db.QueryRow("SELECT id, username, password FROM user WHERE username = ?", "admin")
	err = row.Scan(&id, &username, &password)

	if err != nil {
		log.Printf("[main] scan error: %v", err.Error())
	}

	// fmt.Printf("%s\n", ghostUser.String())
	fmt.Printf("admin user:\nid:%d,\nusername:%s,\npassword:%s\n", id, username, password)
}
