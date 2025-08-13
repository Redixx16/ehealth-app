# Script para eliminar los archivos originales después de la reorganización
# ⚠️ SOLO EJECUTAR DESPUÉS DE VERIFICAR QUE TODO FUNCIONA CORRECTAMENTE

Write-Host "🧹 Limpieza de archivos originales..." -ForegroundColor Yellow
Write-Host "⚠️  Asegúrate de que todos los imports estén actualizados antes de continuar" -ForegroundColor Red

$confirmation = Read-Host "¿Estás seguro de que quieres eliminar los archivos originales? (y/N)"

if ($confirmation -eq "y" -or $confirmation -eq "Y") {
    Write-Host "🗑️  Eliminando archivos originales..." -ForegroundColor Red
    
    # Archivos de Auth
    Remove-Item "lib\presentation\screens\login_screen.dart" -Force
    Remove-Item "lib\presentation\screens\home_dispatcher_screen.dart" -Force
    
    # Archivos de Patient
    Remove-Item "lib\presentation\screens\patient_home_screen.dart" -Force
    Remove-Item "lib\presentation\screens\patient_dashboard_screen.dart" -Force
    Remove-Item "lib\presentation\screens\patient_registration_screen.dart" -Force
    
    # Archivos de Gamification
    Remove-Item "lib\presentation\screens\achievements_screen.dart" -Force
    Remove-Item "lib\presentation\screens\pregnancy_timeline_screen.dart" -Force
    Remove-Item "lib\presentation\screens\progress_stats_screen.dart" -Force
    Remove-Item "lib\presentation\screens\notifications_screen.dart" -Force
    Remove-Item "lib\presentation\screens\education_screen.dart" -Force
    
    # Archivos de Personnel
    Remove-Item "lib\presentation\screens\personnel_home_screen.dart" -Force
    
    # Archivos de Appointments
    Remove-Item "lib\presentation\screens\create_appointment_screen.dart" -Force
    Remove-Item "lib\presentation\screens\edit_appointment_screen.dart" -Force
    Remove-Item "lib\presentation\screens\appointment_detail_screen.dart" -Force
    Remove-Item "lib\presentation\screens\mockup_citas_screen.dart" -Force
    Remove-Item "lib\presentation\screens\crear_cita_mockup.dart" -Force
    
    # Archivos de planificación
    Remove-Item "lib\presentation\screens\organization_plan.md" -Force
    Remove-Item "move_screens.ps1" -Force
    
    Write-Host "✅ Archivos originales eliminados exitosamente!" -ForegroundColor Green
    Write-Host "🎉 Reorganización completada!" -ForegroundColor Green
} else {
    Write-Host "❌ Operación cancelada. Los archivos originales se mantienen." -ForegroundColor Yellow
} 