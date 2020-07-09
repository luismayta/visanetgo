package config

const (
	configFile           = ".env"
	applicationName      = "VisaNet"
	applicationEnvPrefix = "VISANET"
)

// Configuration struct for config
type Configuration struct {
	AppEnv string `env:"VISANET_APP_ENV" envDefault:"test"`
}
