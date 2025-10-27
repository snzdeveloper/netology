#считываем данные об образе ОС
data "yandex_compute_image" "ubuntu-2404-lts" {
  family = "ubuntu-2404-lts"
}

