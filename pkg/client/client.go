package client

import (
  "encoding/base64"
  "fmt"
  "github.com/spf13/viper"
  "io/ioutil"
  "net/http"
)

func clientAuthorization() ([]byte, error) {
  req, err := http.NewRequest("POST", "https://apitestenv.vnforapps.com/api.security/v1/security", nil)
  if err != nil {
    return nil, err
  }
  user := viper.Get("VISANET_DEV_USER")
  pwd := viper.Get("VISANET_DEV_PASSWD")
  encodedCredential := base64.StdEncoding.EncodeToString([]byte(fmt.Sprintf("%s:%s", user, pwd)))
  req.Header.Set("Authorization", fmt.Sprintf("Basic %s", encodedCredential))

  c := &http.Client{}
  res, err := c.Do(req)
  if err != nil {
    return nil, err
  }
  defer res.Body.Close()

  obj, err := ioutil.ReadAll(res.Body)
  if err != nil {
    return nil, err
  }

  if err != nil {
    err = fmt.Errorf("%v: %s", err, string(obj))
    return nil, err
  }

  if res.StatusCode == 201 {
    return obj, nil
  }

  return nil, err
}
