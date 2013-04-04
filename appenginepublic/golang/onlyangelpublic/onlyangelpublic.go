package onlyangelpublic

import (
	"net/http"
	"fmt"
)


func init() {
    http.HandleFunc("/", rootWS)
	http.HandleFunc("/google3fa87da090e4c8e1.html", verification)

    }

func rootWS(w http.ResponseWriter, r *http.Request) {
	//donothing
}


func verification(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w,"google-site-verification: google3fa87da090e4c8e1.html")
}
