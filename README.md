# Multition Infrastructure

Local infrastructure và deployment foundation cho toàn bộ Multition workspace.
Repo này không chứa application business logic hoặc secret thật.

## Yêu cầu layout

```text
workspace/
├── multition-api/
├── multition-ai/
├── multition-infra/
├── multition-mobile/
├── multition-web/
└── multition-docs/
```

## Chạy database và object storage

```bash
cp .env.example .env
docker compose -f compose.dev.yaml up -d postgres minio
```

Nếu chạy API trực tiếp trên máy, chạy migration từ API repo:

```bash
cd ../multition-api
cp .env.example .env
npm install
npm run db:migrate
```

## Chạy API và AI bằng container

```bash
docker compose -f compose.dev.yaml --profile apps up --build
```

Profile `apps` tự chạy service `migrate` trước khi Core API khởi động.

| Service | URL |
|---|---|
| Core API | `http://localhost:4000` |
| AI service | `http://localhost:8000` |
| PostgreSQL | `localhost:5432` |
| MinIO API | `http://localhost:9000` |
| MinIO console | `http://localhost:9001` |

`postgres` và `minio` là profile mặc định. `api` và `ai` nằm trong profile
`apps` để developer có thể chạy dependency bằng Docker nhưng chạy application
trực tiếp với hot reload.

## Clone toàn bộ workspace

Clone repo này trước, rồi dùng:

```bash
./scripts/clone-all.sh
```

Script mặc định clone từ https://github.com/Multition bằng HTTPS. Có thể đặt
`MULTITION_GITHUB_ORG` nếu dùng một organization khác. Các repo còn lại được
clone thành sibling directories, không tạo parent Git repo.

Sau khi clone xong, mở `Multition.code-workspace` trong repo này để thấy cả sáu
repo trong cùng một cửa sổ VS Code.

Hướng dẫn cài đặt và cộng tác: [Developer onboarding](https://github.com/Multition/multition-docs/blob/main/development/onboarding.md).
OpenAPI và công cụ đồng bộ type nằm trong `multition-api/openapi/`.

## Production boundary

- Database và object storage phải dùng managed secrets; không dùng giá trị local.
- Core API và AI service có identity/secret riêng.
- Chỉ Core API được public; AI service chỉ có private ingress.
- Logs phải chứa request ID/agent run ID nhưng không log CV hay document content.
- Backup, migration, error monitoring và rollback phải được kiểm tra trước demo production.
