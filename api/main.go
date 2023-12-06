package main

import (
	"fmt"

	"github.com/AhmetSBulbul/quarterback-protos/pb/user"
)

func main() {
	ghostUser := user.User{
		Id:         0,
		Email:      "jordan@example.com",
		Username:   "ghost",
		Name:       "Michael",
		Lastname:   "Jordan",
		AvatarPath: "https://upload.wikimedia.org/wikipedia/commons/4/44/Black_tea_pot_cropped.jpg",
	}
	fmt.Printf("%s\n", ghostUser.String())
	fmt.Println("It works!")
}
