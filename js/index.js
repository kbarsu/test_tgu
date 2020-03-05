document.querySelector('.js-find-city-form').addEventListener("submit", (e) => {

    e.preventDefault();
    let xhr = new XMLHttpRequest();
    let saveCityBtn = document.querySelector('.js-save-city-btn');
    let cityInfo = document.querySelector('.js-city-info');
    let preloader = document.querySelector('.js-preloader-find');

    saveCityBtn.disabled=true;
    saveCityBtn.setAttribute('data-name', '');
    saveCityBtn.setAttribute('data-latitude', '');
    saveCityBtn.setAttribute('data-longitude', '');

    xhr.open("GET", '?action=find_city&name=' + document.querySelector('.js-find-city-input').value);
    xhr.send();
    preloader.classList.add("spinner-border");
    preloader.classList.add("text-primary");

    xhr.onload = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        if (xhr.status != 200) { 
            cityInfo.innerHTML = `Ошибка ${xhr.status}: ${xhr.statusText}`;
        } else {
            result = JSON.parse(this.responseText);
            if (result.status === 'ok') {
                cityInfo.innerHTML = `Название: ${result.data.city_name}<br/>Широта: ${result.data.latitude}<br/>Долгота: ${result.data.longitude}`;
                saveCityBtn.setAttribute('data-name', result.data.city_name);
                saveCityBtn.setAttribute('data-latitude', result.data.latitude);
                saveCityBtn.setAttribute('data-longitude', result.data.longitude);
                saveCityBtn.disabled=false;
            } else {
                cityInfo.innerHTML = result.message;
            }
      }
    };

    xhr.onerror = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        cityInfo.innerHTML = "Запрос не удался";
    };
    
});

document.querySelector('.js-save-city-btn').addEventListener("click", (e) => {

    let xhr = new XMLHttpRequest();
    let saveCityBtn = document.querySelector('.js-save-city-btn');
    let cityInfo = document.querySelector('.js-city-info');
    let preloader = document.querySelector('.js-preloader-find');

    xhr.open("GET", `?action=save_city&name=${e.target.getAttribute('data-name')}&latitude=${e.target.getAttribute('data-latitude')}&longitude=${e.target.getAttribute('data-longitude')}`);
    xhr.send();
    preloader.classList.add("spinner-border");
    preloader.classList.add("text-primary");

    xhr.onload = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        if (xhr.status != 200) { 
            cityInfo.innerHTML = `Ошибка ${xhr.status}: ${xhr.statusText}`;
        } else {
            result = JSON.parse(this.responseText);
            if (result.status = 'ok') {
                load_cities();
                cityInfo.innerHTML = 'Город ' + e.target.getAttribute('data-name') + ' успешно сохранен';
                saveCityBtn.disabled=true;
                saveCityBtn.setAttribute('data-name', '');
                saveCityBtn.setAttribute('data-latitude', '');
                saveCityBtn.setAttribute('data-longitude', '');
            } else {
                cityInfo.innerHTML = result.message;
            }
      }
    };

    xhr.onerror = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        cityInfo.innerHTML = "Запрос не удался";
    };
    
});

function load_cities() {
    let xhr = new XMLHttpRequest();
    let preloader = document.querySelector('.js-preloader-calculate');
    let distanceInfo = document.querySelector('.js-distance-info');
    let select1 = document.querySelector('.js-calculate-select-1');
    let select2 = document.querySelector('.js-calculate-select-2');

    xhr.open("GET", `?action=get_cities`);
    xhr.send();

    xhr.onload = function() {

        if (xhr.status != 200) { 
            alert(`Ошибка ${xhr.status}: ${xhr.statusText}`);
        } else {
            result = JSON.parse(this.responseText);
            if (result.status = 'ok') {

                select1.innerHTML = '';
                select2.innerHTML = '';

                for (let i = 0; i < result.data.length; i++){
                    let option1 = document.createElement('option');
                    option1.value = result.data[i].id;
                    option1.innerHTML = result.data[i].city_name;
                    option2 = option1.cloneNode(true)
                    select1.appendChild(option1);
                    select2.appendChild(option2);
                }
            } else {
                distanceInfo.innerHTML = result.message;
            }
      }
    };

    xhr.onerror = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        cityInfo.innerHTML = "Запрос не удался";
    };
}

document.querySelector('.js-calculate-form').addEventListener("submit", (e) => {

    e.preventDefault();
    let xhr = new XMLHttpRequest();
    let select1 = document.querySelector('.js-calculate-select-1');
    let select2 = document.querySelector('.js-calculate-select-2');
    let distanceInfo = document.querySelector('.js-distance-info');
    let preloader = document.querySelector('.js-preloader-calculate');

    xhr.open("GET", `?action=get_distance&city1=${select1.value}&city2=${select2.value}`);
    xhr.send();
    preloader.classList.add("spinner-border");
    preloader.classList.add("text-primary");

    xhr.onload = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        if (xhr.status != 200) { 
            distanceInfo.innerHTML = `Ошибка ${xhr.status}: ${xhr.statusText}`;
        } else {
            result = JSON.parse(this.responseText);
            if (result.status === 'ok') {
                distanceInfo.innerHTML = `Дистанция между городами ${result.data.city1} и ${result.data.city2}: <b>${result.data.distance} км</b>`;
            } else {
                distanceInfo.innerHTML = result.message;
            }
      }
    };

    xhr.onerror = function() {
        preloader.classList.remove("spinner-border");
        preloader.classList.remove("text-primary");
        distanceInfo.innerHTML = "Запрос не удался";
    };
    
});

load_cities();