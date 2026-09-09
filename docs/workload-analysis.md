# Workload Analysis — Lean Project Control

_วันที่วิเคราะห์: 2026-09-07_

## 1. ข้อมูลที่ระบบบันทึกไว้แล้ว

### 1.1 Tasks (งาน)

| ฟิลด์ | ความหมาย |
|---|---|
| `task_code` | รหัสงาน เช่น `RRMS-T-001` |
| `task_name` | ชื่องาน |
| `task_type` | MainTask / Task / Subtask |
| `status` | NotStarted / InProgress / Done / Blocked / OnHold |
| `rag_status` | สัญญาณสี: Green / Amber / Red |
| `progress` | % ความคืบหน้า (0–100) |
| `planned_start_date` | วันเริ่มตามแผน |
| `planned_due_date` | วันครบกำหนดตามแผน |
| `owner_person_id` | ผู้รับผิดชอบหลัก |
| `workstream` | สายงาน เช่น BE, FE, QA, INFRA |
| `weight` | น้ำหนักสำหรับคำนวณ weighted progress |
| `evidence_required` | ต้องการหลักฐานหรือไม่ |

### 1.2 Task Assignments (การมอบหมายงาน)

| ฟิลด์ | ความหมาย |
|---|---|
| `person_id` | คนที่ถูก assign |
| `assignment_role` | Owner / BA / DEV / QA / Reviewer / Contributor / Observer |
| `raci_role` | Responsible / Accountable / Consulted / Informed |
| `allocation_percent` | % เวลาที่จัดสรร (0–100) |
| `is_primary` | เป็นผู้รับผิดชอบหลักหรือไม่ |

### 1.3 Weekly Updates (อัปเดตรายสัปดาห์)

| ฟิลด์ | ความหมาย |
|---|---|
| `week_start_date` | สัปดาห์ที่รายงาน |
| `progress` | % ความคืบหน้าที่รายงาน |
| `status` | สถานะงานในสัปดาห์นั้น |
| `rag_status` | สัญญาณสีในสัปดาห์นั้น |
| `summary` | สรุปความคืบหน้า |
| `blocker` | ปัญหาที่ติดขัด |
| `next_step` | ขั้นตอนถัดไป |

### 1.4 Weekly Plans (แผนรายสัปดาห์)

| ฟิลด์ | ความหมาย |
|---|---|
| `plan_title` | หัวข้อแผน |
| `owner_person_id` | เจ้าของแผน |
| `target_outcome` | ผลลัพธ์ที่คาดหวัง |
| `planned_due_date` | กำหนดเสร็จในสัปดาห์ |
| `priority` | Low / Medium / High / Critical |
| `status` | Planned / InProgress / Done / Deferred |

### 1.5 RAID Register

เก็บ Risk / Assumption / Issue / Decision พร้อม `severity_score` และ `status`

---

## 2. Workload ต่อบุคคล — สิ่งที่คำนวณได้จากข้อมูลปัจจุบัน

ระบบสามารถคำนวณ **Workload per Person** ได้ทันทีจากข้อมูลที่มีอยู่:

```
งานที่ Assign ให้คน X (via task owner หรือ task_assignments)
  ที่ยังไม่เสร็จ (status ≠ Done):
    → จำนวนงานทั้งหมด
    → % progress เฉลี่ย
    → งานที่ Blocked หรือ Red RAG
    → งานที่ Overdue (planned_due_date < today)
    → งานที่ due ในสัปดาห์นี้
    → blocker ล่าสุดที่รายงาน
```

---

## 3. ข้อมูลสรุปสำหรับตัดสินใจ (Decision-Making)

### 3.1 Workload ต่อบุคคล
| ข้อมูล | สถานะ |
|---|:---:|
| จำนวนงานที่ยังไม่เสร็จต่อคน | ✅ |
| % progress เฉลี่ยต่อคน | ✅ |
| งาน Overdue ต่อคน | ✅ |
| งาน Blocked/Red ต่อคน | ✅ |
| งาน due สัปดาห์นี้ต่อคน | ✅ |
| หน้า UI Workload View | ✅ (สร้างแล้ว) |

### 3.2 สัญญาณเตือน (Early Warning)
| ข้อมูล | สถานะ |
|---|:---:|
| งาน Red/Amber RAG | ✅ |
| RAID ความเสี่ยงสูง (severity_score ≥ 12) | ✅ |
| งาน Blocked ทั้งโปรเจกต์ | ✅ |
| งาน Overdue ทั้งโปรเจกต์ | ✅ |

### 3.3 ติดตามความคืบหน้า
| ข้อมูล | สถานะ |
|---|:---:|
| Weekly Update history ต่องาน | ✅ |
| Blocker ที่รายงานในสัปดาห์นี้ | ✅ |
| Next steps ต่องาน | ✅ |
| Role updates (accomplished/next) | ✅ |

### 3.4 ข้อมูลที่ยังไม่มี (Future Enhancement)
| ข้อมูล | เหตุผล |
|---|---|
| Actual hours / effort logged | ไม่มี time-tracking |
| Capacity ของแต่ละคน (วัน/สัปดาห์) | ไม่มีฟิลด์ capacity |
| Workload forecast อนาคต | ไม่มีการ estimate effort |

---

## 4. API Endpoints ที่เพิ่มใหม่

### `GET /api/workload`

คืนค่า Workload summary สำหรับทุกคนในโปรเจกต์

**Response:**
```json
{
  "today": "2026-09-07",
  "weekStart": "2026-09-07",
  "members": [
    {
      "person_id": "...",
      "display_name": "ชื่อ นามสกุล",
      "employee_code": "EMP001",
      "department": "IT",
      "position_title": "Developer",
      "project_role": "DEVLead",
      "total": 8,
      "in_progress": 3,
      "not_started": 2,
      "blocked": 1,
      "on_hold": 0,
      "overdue": 2,
      "due_this_week": 3,
      "avg_progress": 47,
      "rag_red": 1,
      "rag_amber": 3,
      "rag_green": 4,
      "tasks": [ ... ]
    }
  ]
}
```

---

## 5. หน้า UI ที่สร้างใหม่: Workload View

เพิ่มหน้า **"Workload"** ในระบบ ซึ่งแสดง:

1. **ตารางสรุปทีม** — แต่ละคนมีงานค้างกี่รายการ, Overdue, Red RAG, progress เฉลี่ย
2. **คลิกดูรายละเอียดต่อบุคคล** — รายการงานทั้งหมดที่ assign ไว้และยังไม่เสร็จ พร้อม due date, status, RAG
3. **Filter** — ดูเฉพาะคนที่มี Overdue / Blocked / Red RAG

---

_วิเคราะห์โดย: Antigravity AI Assistant_
