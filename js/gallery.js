document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("#year").forEach((el) => { el.textContent = new Date().getFullYear(); });
  document.querySelectorAll(".skill").forEach((skill) => {
    const progress = skill.querySelector(".skill-progress");
    const label = skill.querySelector(".skill-percent");
    if (!progress || !label) return;
    const percent = Math.min(100, Math.max(0, Number(progress.dataset.percent) || 0));
    progress.style.width = `${percent}%`;
    label.textContent = `${percent}%`;
  });
});
