use pyo3::prelude::*;
use pyo3::types::{PyDict, PyList};
use lumentum_core::engine::Engine;

#[pyfunction]
fn process(py: Python, text: &str) -> PyResult<PyObject> {
    let e = Engine::new();
    let tokens = e.process(text);

    let list = PyList::empty_bound(py);
    for t in tokens {
        let dict = PyDict::new_bound(py);
        dict.set_item("token", t.token)?;
        dict.set_item("focus_index", t.focus_index)?;
        dict.set_item("pace_ms", t.pace_ms)?;
        list.append(dict)?;
    }

    Ok(list.to_object(py))
}

#[pymodule]
fn lumentum_py(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(process, m)?)?;
    Ok(())
}
