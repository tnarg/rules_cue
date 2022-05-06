import (
	"github.com/tnarg/rules_cue/examples/lang:en"
	"github.com/tnarg/rules_cue/examples/lang:de"
)

#Def: {
	message:       en.message | de.message
	random_number: >12
	extra?:        bool
}

close({})
