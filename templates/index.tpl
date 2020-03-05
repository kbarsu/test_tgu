<!doctype html>
<html lang="ru">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
  <title>Определение дистанции</title>
  <style>
    body {
      padding: 30px;
    }
  </style>
</head>

<body>

  <div class="container-fluid">

    <ul class="nav nav-tabs">
      <li class="nav-item">
        <a class="nav-link active" data-toggle="tab" href="#add_cities">Поиск городов</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" data-toggle="tab" href="#calculate">Рассчет дистанции</a>
      </li>
    </ul>
    <div class="tab-content p-3">
      <div class="tab-pane fade show active" id="add_cities">
        <form class='js-find-city-form'>
            <h2 class="h4 mb-3">Введите название города</h2>
            <div class="form-group">
                <input name="city_name" type="text" class="js-find-city-input" />
            </div>
            <div class="form-group">
                <span class="js-city-info">Здесь будет инфа о городе</span>
            </div>
            <div class="form-group">
                <button class="btn btn-primary js-find-city-btn" type="submit">Найти</button>
                <button class="btn btn-primary js-save-city-btn" type="button" disabled>Сохранить</button>
            </div>
            <div class="js-preloader-find"></div>
        </form>
      </div>
      <div class="tab-pane fade" id="calculate">
        <form class='js-calculate-form'>
            <h2 class="h4 mb-3">Выберите два города</h2>
            <div class="form-group">
                <div class="row">
                    <div class="col-sm-6 col-md-4 col-lg-2">
                        <select name="city1" class="form-control js-calculate-select-1">
                        </select>
                    </div>
                    <div class="col-sm-6 col-md-4 col-lg-2">
                        <select name="city2" class="form-control js-calculate-select-2">
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <span class="js-distance-info">Здесь будет инфа о расстоянии</span>
            </div>
            <div class="form-group">
                <button class="btn btn-primary js-calculate-btn" type="submit">Рассчитать</button>
            </div>
            <div class="js-preloader-calculate"></div>
        </form>
      </div>
  </div>

</body>
  <script src="js/index.js"></script>
</html>