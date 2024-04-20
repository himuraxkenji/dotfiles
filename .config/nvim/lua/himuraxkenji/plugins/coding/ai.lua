-- https://github.com/David-Kunz/gen.nvim
-- TODO:
return {
	"David-Kunz/gen.nvim",
	config = function()
		require("gen").prompts["software engineer!"] = {
			prompt = "You are a senior software engineer, acting as an assistant. You answer with code example when possible. $input:\n$text",
			replace = true,
		}
	end,
	opts = {
		model = "mistral",
		url = "http://127.0.0.1:11434",
		serve = {
			on_start = false,
			command = "ollama",
			args = { "serve" },
			stop_command = "pkill",
			stop_args = { "-SIGTERM", "ollama" },
		},
	},
}
