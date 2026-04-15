-- Enable relative motions with relative line numbers
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "cache_or_first" })

-- Sets up git markers for repositories
th.git = th.git or {}

th.git.modified_sign = "󰜥"
th.git.modified = ui.Style():fg("lightyellow"):bold()

th.git.added_sign = ""
-- th.git.added

th.git.untracked_sign = ""
th.git.untracked = ui.Style():fg("lightblue")

th.git.ignored_sign = ""
th.git.ignored = ui.Style():fg("darkgrey"):bold()

th.git.deleted_sign = ""
-- th.git.deleted

th.git.updated_sign = ""
th.git.updated = ui.Style():fg("lightblue"):bold()
require("git"):setup()
