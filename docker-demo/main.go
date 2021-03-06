package main

// TODO:
//   Cleanup image info (spaces to separate from "Served from" message
//   Add verbose template index.html.tmpl.verbose.tmpl to handle extra info

import (
	"flag"
	"fmt"
	"html/template"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
	"io/ioutil"
	"time"    // Used for Sleep
	"strconv" // Used to get integer from string
	// "encoding/json"
)

const (
	// Courtesy of "telnet mapascii.me"
	image_name_version = "docker-demo"
	image_version      = 1
	MAP_ASCII_ART      = "static/img/mapascii.txt"
        LOGO_ASCII_ART     = "static/img/docker_blue.txt"
	escape             = "\x1b"
	colour_me_yellow   = escape + "[1;33m"
	colour_me_normal   = escape + "[0;0m"
)

var (
	mux        = http.NewServeMux()
	listenAddr string
	verbose    bool
	headers    bool
)

type (
	Content struct {
		Title       string
		Hostname    string
		Image       string
		NetworkInfo string
		RequestPP   string
	}
)

// -----------------------------------
// func: init
//
// Read command-line arguments:
//
func init() {
	flag.StringVar(&listenAddr, "listen", ":80", "listen address")
	flag.BoolVar(&verbose,      "v",      false,   "verbose (false)")
	flag.BoolVar(&headers,      "h",      false,   "show headers (false)")
}

// -----------------------------------
// func: loadTemplate
//
// load template file and substitute variables
//
func loadTemplate(filename string) (*template.Template, error) {
	return template.ParseFiles(filename)
}

// -----------------------------------
// func: CaseInsensitiveContains
//
// Do case insensitive match - of substr in s
//
func CaseInsensitiveContains(s, substr string) bool {
        s, substr = strings.ToUpper(s), strings.ToUpper(substr)
        return strings.Contains(s, substr)
}

// -----------------------------------
// func: formatRequestHandler
//
// generates ascii representation of a request
//
// From: https://medium.com/doing-things-right/pretty-printing-http-requests-in-golang-a918d5aaa000
//
func formatRequestHandler(w http.ResponseWriter, r *http.Request) {
    ret := formatRequest(r)

    fmt.Fprintf(w, "%s", ret)
    return
}

// -----------------------------------
// func: formatRequest
//
// generates ascii representation of a request
//
// From: https://medium.com/doing-things-right/pretty-printing-http-requests-in-golang-a918d5aaa000
//
func formatRequest(r *http.Request) string {
    // Create return string
    var request []string

    // Add the request string
    url := fmt.Sprintf("%v %v %v", r.Method, r.URL, r.Proto)
    request = append(request, url)

    // Add the host
    request = append(request, fmt.Sprintf("Host: %v", r.Host))

    // Loop through headers
    for name, headers := range r.Header {
        name = strings.ToLower(name)
        for _, h := range headers {
            request = append(request, fmt.Sprintf("%v: %v", name, h))
        }
    }

    // If this is a POST, add post data
    if r.Method == "POST" {
        r.ParseForm()
        request = append(request, "\n")
        request = append(request, r.Form.Encode())
    }

    // Return the request as a string
    return strings.Join(request, "\n")
}

// -----------------------------------
// func: statusCodeTest
//
// Example handler - sets status code
//
func statusCodeTest(w http.ResponseWriter, req *http.Request) {
    //m := map[string]string{
        //"foo": "bar",
    //}
    //w.Header().Add("Content-Type", "application/json")

    //num := http.StatusCreated
    num := http.StatusInternalServerError

    w.WriteHeader( num )

    //_ = json.NewEncoder(w).Encode(m)
    fmt.Fprintf(w, "\nWriting status code <%d>\n", num)
}

// -----------------------------------
// func: index
//
// Main index handler - handles different requests
//
func index(w http.ResponseWriter, r *http.Request) {
	log.Printf("Request from '%s' (%s)\n", r.Header.Get("X-Forwarded-For"), r.URL.Path)

	hostname, err := os.Hostname()
	if err != nil {
		hostname = "unknown"
	}

        // image_version 3: return early with status code 404 or /CODE (from r.URL.Path)
        //
        if image_version == 3 {
            //fmt.Fprintf(w, "\nPATH=<%s>", r.URL.Path)
            //if r.URL.Path == "/map" || r.URL.Path == "/MAP" {}

            num, err := strconv.Atoi( r.URL.Path[1:] )
            if err == nil {
                // how to set numeric status code?
                // http.Error(w, http.StatusText(num), num)

                //num = http.StatusInternalServerError
                w.WriteHeader( num )
                fmt.Fprintf(w, "\nWriting status code <%d>\n", num)
            } else {
                fmt.Fprintf(w, "\nWriting default status code <NotFound>\n")
                http.NotFound(w, r)
            }

            return
        }

        // image_version 4: return content after delay of 60 secs or /SECS (from r.URL.Path)
        //
        if image_version == 4 {
            fmt.Fprintf(w, "\nPATH=<%s>", r.URL.Path)

	    DEFAULT_SECS := 60

            delay := time.Duration(DEFAULT_SECS) * 1000 * time.Millisecond

            num, err := strconv.Atoi( r.URL.Path[1:] )
            if err == nil {
                fmt.Fprintf(w, "\nSleeping <%d> secs\n", num)
                delay = time.Duration(num) * 1000 * time.Millisecond
            } else {
                fmt.Fprintf(w, "\nSleeping default <%d> secs\n", DEFAULT_SECS)
            }

	    time.Sleep(delay)
        }

        // Get user-agent: if text-browser, e.g. wget/curl/httpie/lynx/elinks return ascii-text image:
        //
        userAgent := r.Header.Get("User-Agent")

        networkInfo := ""
        requestPP   := ""
        if verbose {
            networkInfo = getNetworkInfo()
        }
        if headers {
            requestPP   = formatRequest(r)
        }

        if CaseInsensitiveContains(userAgent, "wget") ||
            CaseInsensitiveContains(userAgent, "curl") ||
            CaseInsensitiveContains(userAgent, "httpie") ||
            CaseInsensitiveContains(userAgent, "links") ||
            CaseInsensitiveContains(userAgent, "lynx") {
            w.Header().Set("Content-Type", "text/txt")

            fmt.Fprintf(w, "\n%s", requestPP)
            var content []byte

	    if r.URL.Path == "/map" || r.URL.Path == "/MAP" {
	        content, _ = ioutil.ReadFile( MAP_ASCII_ART )
            } else {
	        content, _ = ioutil.ReadFile( LOGO_ASCII_ART )
            }

	    w.Write([]byte(content))
            fmt.Fprintf(w, "\nServed from container %s%s%s\nUsing image %s\n", colour_me_yellow, hostname, colour_me_normal, image_name_version)

            fmt.Fprintf(w, "%s", networkInfo)

	    return
	}

	// else return html as normal ...
        //
        templateFile := "templates/index.html.tmpl"

	t, err := loadTemplate(templateFile)
	if err != nil {
		log.Printf("error loading template from %s: %s\n", templateFile, err)
		return
	}

	title := os.Getenv("TITLE")

	cnt := &Content{
		Title:    title,
		Hostname: hostname,
		Image:    image_name_version,
		NetworkInfo:  networkInfo,
		RequestPP:  requestPP,
        }

        // apply Context values to template
	t.Execute(w, cnt)
}

func getNetworkInfo() string {
    ret := "Network interfaces:\n"

    ifaces, _ := net.Interfaces()
    // handle err
    for _, i := range ifaces {
        addrs, _ := i.Addrs()
        // handle err
        for _, addr := range addrs {
            var ip net.IP
            switch v := addr.(type) {
                case *net.IPNet:
                    ip = v.IP
                case *net.IPAddr:
                    ip = v.IP
                }
            // process IP address
            ret = fmt.Sprintf("%sip %s\n", ret, ip.String())
        }
    }
    ret = fmt.Sprintf("%slistening on port %s\n", ret, listenAddr)

    return ret
}

// -----------------------------------
// func: ping
//
// Ping handler - echos back remote address
//
func ping(w http.ResponseWriter, r *http.Request) {
	resp := fmt.Sprintf("ping: hello %s\n", r.RemoteAddr)
	w.Write([]byte(resp))
}

// -----------------------------------
// func: main
//
//
//
func main() {
	flag.Parse()

	mux.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("./static"))))
	mux.HandleFunc("/", index)
	mux.HandleFunc("/test", statusCodeTest)

	mux.HandleFunc("/echo", formatRequestHandler)
	mux.HandleFunc("/ECHO", formatRequestHandler)

	mux.HandleFunc("/ping", ping)
	mux.HandleFunc("/PING", ping)

	mux.HandleFunc("/MAP", index)
	mux.HandleFunc("/map", index)

	log.Printf("listening on %s\n", listenAddr)

	if err := http.ListenAndServe(listenAddr, mux); err != nil {
		log.Fatalf("error serving: %s", err)
	}
}

