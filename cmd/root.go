package cmd

import (
	"fmt"
	"os"

	"github.com/equipindustry/visanetgo/config"

	pkg "github.com/equipindustry/visanetgo/pkg/version"
	"github.com/spf13/cobra"
)

var (
	version bool
)

func init() {
	cobra.OnInitialize()
	rootCmd.Flags().BoolVarP(&version, "version", "v", false, "show current version of CLI")
}

var rootCmd = &cobra.Command{
	Use:   "Visanet Client",
	Short: "Visanet client api",
	Long: `Visanet client
                love by EquipIndustry in Go.
                Complete documentation is available at https://github.com/equipindustry/visanetgo`,
	PreRunE: func(cmd *cobra.Command, args []string) error {
		return config.InitializeViper()
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		if version {
			return printVersion()
		}
		return cmd.Help()
	},
}

func printVersion() error {
	fmt.Println("Version: ", pkg.Version)
	return nil
}

// Execute command cmd
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
