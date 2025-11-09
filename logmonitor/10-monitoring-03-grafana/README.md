# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

<img src="https://github.com/snzdeveloper/netology/blob/main/logmonitor/10-monitoring-03-grafana/Screenshot_20251106_173619.jpg" width="100%">  

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

<img src="https://github.com/snzdeveloper/netology/blob/main/logmonitor/10-monitoring-03-grafana/Screenshot_11-09-2025_01.jpg" width="100%">  

- утилизация CPU для nodeexporter (в процентах, 100-idle);
    > 100 - (avg by (instance) (irate(node_cpu_seconds_total{job=\"nodeexporter\",mode=\"idle\"}[30s])) * 100)

- CPULA 1/5/15;
    > node_load1; node_load5; node_load15

- количество свободной оперативной памяти;
    > node_memory_MemFree_bytes

- количество места на файловой системе.
    > node_filesystem_size_bytes{mountpoint="/"}

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

<img src="https://github.com/snzdeveloper/netology/blob/main/logmonitor/10-monitoring-03-grafana/Screenshot_11-09-2025_02.jpg" width="100%">  

<img src="https://github.com/snzdeveloper/netology/blob/main/logmonitor/10-monitoring-03-grafana/Screenshot_11-09-2025_03.jpg" width="100%">  

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

```json
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 1,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "3PLI8PzDk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "fieldMinMax": true,
          "mappings": [],
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "#EAB839",
                "value": 70
              },
              {
                "color": "red",
                "value": 90
              }
            ]
          },
          "unit": "bytes"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 5,
      "options": {
        "minVizHeight": 75,
        "minVizWidth": 75,
        "orientation": "auto",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true,
        "sizing": "auto"
      },
      "pluginVersion": "12.2.1",
      "targets": [
        {
          "editorMode": "builder",
          "expr": "node_memory_MemFree_bytes",
          "legendFormat": "MEM Free",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "editorMode": "builder",
          "exemplar": false,
          "expr": "node_filesystem_avail_bytes{mountpoint=\"/\"}",
          "hide": false,
          "instant": false,
          "interval": "",
          "legendFormat": "FS (/)",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "editorMode": "builder",
          "expr": "node_filesystem_size_bytes{mountpoint=\"/\"}",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "editorMode": "builder",
          "expr": "node_memory_MemTotal_bytes",
          "hide": false,
          "instant": false,
          "legendFormat": "__auto",
          "range": true,
          "refId": "D"
        }
      ],
      "title": "Frees",
      "transformations": [
        {
          "id": "configFromData",
          "options": {
            "applyTo": {
              "id": "byName",
              "options": "FS (/)"
            },
            "configRefId": "C",
            "mappings": []
          }
        },
        {
          "id": "configFromData",
          "options": {
            "applyTo": {
              "id": "byName",
              "options": "MEM"
            },
            "configRefId": "D",
            "mappings": []
          }
        }
      ],
      "type": "gauge"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "3PLI8PzDk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "showValues": false,
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "id": 2,
      "options": {
        "alertThreshold": true,
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "12.2.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{job=\"nodeexporter\",mode=\"idle\"}[30s])) * 100)",
          "interval": "",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "CPU %",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "3PLI8PzDk"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 17
      },
      "id": 4,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "text": {},
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "12.2.1",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "editorMode": "code",
          "expr": "node_load1",
          "interval": "",
          "legendFormat": "load 1",
          "range": true,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "editorMode": "code",
          "expr": "node_load5",
          "hide": false,
          "interval": "",
          "legendFormat": "load5",
          "range": true,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "3PLI8PzDk"
          },
          "editorMode": "code",
          "expr": "node_load15",
          "hide": false,
          "interval": "",
          "legendFormat": "load15",
          "range": true,
          "refId": "C"
        }
      ],
      "title": "CPULA 1/5/15",
      "type": "stat"
    }
  ],
  "preload": false,
  "refresh": "",
  "schemaVersion": 42,
  "tags": [],
  "templating": {
    "list": [
      {
        "current": {
          "text": "node_filesystem_size_bytes{device=\"/dev/mapper/rl-root\",fstype=\"xfs\",instance=\"node_exporter:9100\",job=\"nodeexporter\",mountpoint=\"/\"} 75094818816 1762705623000",
          "value": "node_filesystem_size_bytes{device=\"/dev/mapper/rl-root\",fstype=\"xfs\",instance=\"node_exporter:9100\",job=\"nodeexporter\",mountpoint=\"/\"} 75094818816 1762705623000"
        },
        "definition": "query_result(node_filesystem_size_bytes{mountpoint=\"/\"})",
        "name": "fssize",
        "options": [],
        "query": {
          "qryType": 3,
          "query": "query_result(node_filesystem_size_bytes{mountpoint=\"/\"})",
          "refId": "PrometheusVariableQueryEditor-VariableQuery"
        },
        "refresh": 2,
        "regex": "",
        "type": "query"
      }
    ]
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "New dashboard Copy",
  "uid": "20e0_PkDk",
  "version": 14
}
```

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
