const user = document.getElementById('usuario')
const password = document.getElementById('password')
const error = document.getElementById('error')

const form = document.getElementById('form-data')

form.addEventListener('submit', (e) => {
    let messages = []
    if (user.value.includes(" "))
    {
        messages.push("El usuario no puede tener espacios en blanco")
    }
    if (password.value.length <= 6)
    {
        messages.push("La contraseña debe ser mayor a 6 caracteres")
    }
    if (password.value.includes(" "))
    {
        messages.push("La contraseña no puede tener espacios en blanco")
    }
    if (messages.length > 0)
    {
        error.innerHTML = ""
        messages.forEach(message => {
            const temp_error = document.createElement('text')
            temp_error.innerText = message
            temp_error.className = 'error'
            error.appendChild(temp_error)    
        });
        e.preventDefault()
    }
})
