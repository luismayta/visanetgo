package config_test

import (
	"github.com/joho/godotenv"
	log "github.com/sirupsen/logrus"
)

func init() {
	var err error
	if err = godotenv.Load("./../fixtures/test.env"); err != nil {
		log.Debug("not found env")
	}
}
