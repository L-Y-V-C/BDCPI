const imgDiv = document.querySelector('.user_img');
const img = document.querySelector("#foto");
const file = document.querySelector('#file');
const uploadBtn = document.querySelector('#upload_btn');
const fileName = document.querySelector('#file_name');

file.addEventListener('change', function(){
    const chosen_file = this.files[0];
    if (chosen_file)
    {
        const reader = new FileReader();
        reader.addEventListener('load', function(){
            img.setAttribute('src', reader.result);
        })
        reader.readAsDataURL(chosen_file);
        fileName.textContent = chosen_file.name;
    }
})