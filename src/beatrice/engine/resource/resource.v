module resource

import os

pub struct Resource {
pub mut:
	name string
	path string

	ready bool
}

pub fn Resource.create(path string) &Resource {
	mut res := &Resource{}

	if path.len > 0 && !os.exists(path) {
		eprintln('Resource: File not found!!! [${path}]')
	}

	return res
}
