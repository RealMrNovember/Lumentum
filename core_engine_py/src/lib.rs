use pyo3::prelude::*;
use lumentum_core::engine::Engine;

#[pyfunction]
fn process(text: &str) -> PyResult<String> {
    let e = Engine::new();
    Ok(e.process(text))
}

#[pymodule]
fn lumentum_py(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(process, m)?)?;
    Ok(())
}
