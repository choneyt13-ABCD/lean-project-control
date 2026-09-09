# คู่มือการ Deploy ระบบขึ้น Cloud (Free Tier 100%)

เอกสารนี้แนะนำขั้นตอนการนำ Lean Project Control ขึ้นระบบบน Cloud โดยใช้ Free Tier สำหรับทดสอบร่วมกับทีม (Shared Pilot) อย่างปลอดภัย ข้อมูลไม่สูญหาย และประหยัดงบประมาณสูงสุด

---

## สถาปัตยกรรม Free Tier

```
[ผู้ใช้งานในทีม]
       │
       ▼ (HTTPS)
[Cloudflare Pages / Vercel] ── Frontend (Static HTML/CSS/JS) ฟรีตลอดไป
       │
       ▼ (REST API / Bearer Token)
[Render.com / Koyeb] ──────── Fastify Backend API (Container Node.js)
       │
       ▼ (PostgreSQL Connection String)
[Neon.tech / Supabase] ────── Managed PostgreSQL 16 (ฟรี 0.5 GB ไม่หายเมื่อ Restart)
```

---

## ขั้นตอนที่ 1: เตรียม Database บน Neon.tech (ฟรี)

1. สมัครบัญชีที่ [https://neon.tech](https://neon.tech) (เข้าสู่ระบบด้วย Google หรือ GitHub)
2. สร้าง Project ใหม่ ตั้งชื่อว่า `lean-project-control`
3. เลือก Region ที่ใกล้ที่สุด (เช่น `Singapore - ap-southeast-1`)
4. คัดลอก **Connection String** ที่ได้ ซึ่งจะมีรูปแบบ:
   ```text
   postgresql://<username>:<password>@<ep-xyz>.ap-southeast-1.aws.neon.tech/neondb?sslmode=require
   ```
5. รัน Migration เพื่อสร้างตารางทั้งหมดในฐานข้อมูลใหม่:
   ```powershell
   $env:DATABASE_URL="postgresql://<username>:<password>@<ep-xyz>.ap-southeast-1.aws.neon.tech/neondb?sslmode=require"
   npm run migrate
   ```

---

## ขั้นตอนที่ 2: เตรียม API_SECRET_KEY สำหรับความปลอดภัย

เพื่อป้องกันไม่ให้ผู้ไม่ได้รับอนุญาตเรียกใช้งาน API ให้สร้าง Secret Token แบบสุ่ม:

```powershell
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```
*(เก็บ Token นี้ไว้ใช้ในขั้นตอนถัดไป)*

---

## ขั้นตอนที่ 3: Deploy Backend บน Render.com (ฟรี)

1. สมัครบัญชีที่ [https://render.com](https://render.com)
2. กด **New +** -> **Web Service** -> เชื่อมต่อกับ Git Repository ของคุณ
3. ตั้งค่า Service:
   - **Environment:** Node
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
4. ในส่วน **Environment Variables** เพิ่มค่าดังนี้:
   | Key | Value | คำอธิบาย |
   | :--- | :--- | :--- |
   | `DATABASE_PROVIDER` | `postgres` | บอกให้ระบบใช้งาน PostgreSQL |
   | `DATABASE_URL` | *(Connection String จาก Neon)* | URL เชื่อมต่อ Neon DB |
   | `HOST` | `0.0.0.0` | ให้ Container รับ Traffic จากภายนอก |
   | `PORT` | `10000` | Render กำหนดพอร์ตเริ่มต้นเป็น 10000 |
   | `API_SECRET_KEY` | *(Secret Token ที่สร้างในข้อ 2)* | ล็อกความปลอดภัย API |
   | `ALLOW_DEMO_IDENTITY_OVERRIDE` | `false` | ปิดโหมด override สำหรับความปลอดภัย |

5. กด **Create Web Service** และรอจนระบบ Deploy เสร็จ จะได้ URL เช่น:
   ```text
   https://lean-project-api.onrender.com
   ```

---

## ขั้นตอนที่ 4: Deploy Frontend บน Cloudflare Pages (ฟรี)

1. เข้า [Cloudflare Dashboard](https://dash.cloudflare.com) -> **Workers & Pages** -> **Create application** -> **Pages**
2. เชื่อมต่อ Git Repository
3. ตั้งค่า Build:
   - **Build command:** *(เว้นว่างไว้)*
   - **Build output directory:** `apps/web`
4. กด **Save and Deploy** จะได้ URL เช่น:
   ```text
   https://lean-project-control.pages.dev
   ```

---

## ขั้นตอนที่ 5: ล็อกความปลอดภัยขั้นสูงสุดด้วย Cloudflare Zero Trust (ฟรี ≤ 50 Users)

เพื่อความปลอดภัยระดับองค์กร ให้คนในทีมเท่านั้นที่เข้าถึงหน้าเว็บได้:
1. ใน Cloudflare Dashboard ไปที่ **Zero Trust** -> **Access** -> **Applications**
2. กด **Add an application** -> เลือก **Self-hosted**
3. ใส่ Domain ของ Frontend เช่น `lean-project-control.pages.dev`
4. กำหนด **Policy**: อนุญาตเฉพาะอีเมลที่มี Domain องค์กร (เช่น `@yourcompany.com`) หรือระบุรายชื่ออีเมลของทีม
5. บันทึก Policy: เมื่อใครก็ตามเปิดลิงก์เข้ามา จะต้องกรอกรหัส OTP จากอีเมลก่อนจึงจะเข้าหน้าเว็บได้
