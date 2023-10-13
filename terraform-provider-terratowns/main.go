package main

import (
	//"fmt"
	//"log"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	//"github.com/google/uuid"
)
func main () {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,

	})
}

func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{

		},
		DataSourcesMap: map[string]*schema.Resource{

		},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "API Endpoint",
			},
			"token": {
				Type: schema.TypeString,
				Required: true,
				Sensitive: true, // Makes token sensitive for TF logs
				Description: "API token",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "UUID of User Making call",
				//ValidateFunc: validateUUID,
			},
		},
	}
	//p.ConfigureContextFunc = providerConfigure(p)
	return p
}

//func validateUUID(val interface{}, key string) (warns []string, errors []error) {
//log.Print('validateUUID:start')
//value := v.(string)
//if _,err = uuid.Parse(value); err != nil {
//		errors = append(error, fmt.Errorf("invalid uuid format"))
//	}
//	log.Print('validateUUID:end')

//}