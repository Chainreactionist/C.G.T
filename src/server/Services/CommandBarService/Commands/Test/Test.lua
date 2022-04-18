return {
	Name = "test",
	Aliases = {},
	Description = "Test.",
	Group = "Owners, Admins, Moderators", --The string just has to contain everyone that has access to these commands and is checked by the Hooks.Permissions BeforeRun function
	Args = {
		{
			Type = "string",
			Name = "input",
			Description = "some input",
		},
	},
}
