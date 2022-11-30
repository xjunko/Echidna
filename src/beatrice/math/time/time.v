module time

pub struct Time[T] {
pub mut:
	start T
	end   T
}

pub fn (time Time[T]) str() string {
	return 'Time<${typeof(time.start).name}>{start=${time.start}, end=${time.end}}>'
}

pub fn (time Time[T]) duration() T {
	return time.end - time.start
}
