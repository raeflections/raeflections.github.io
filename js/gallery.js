document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("#year").forEach((el) => {
    el.textContent = new Date().getFullYear();
  });

  const lightbox = document.getElementById("lightbox");
  if (!lightbox) return;

  const image = document.getElementById("lightbox-image");
  const title = document.getElementById("lightbox-title");
  const tags = document.getElementById("lightbox-tags");
  const closeButton = lightbox.querySelector(".lightbox-close");

  const closeLightbox = () => {
    lightbox.classList.remove("open");
    lightbox.setAttribute("aria-hidden", "true");
    image.src = "";
    document.body.style.overflow = "";
  };

  document.querySelectorAll(".photo-button").forEach((button) => {
    button.addEventListener("click", () => {
      if (button.classList.contains("missing")) return;

      image.src = button.dataset.full;
      image.alt = button.dataset.title || "Photograph";
      title.textContent = button.dataset.title || "";
      tags.textContent = button.dataset.tags || "";

      lightbox.classList.add("open");
      lightbox.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    });
  });

  closeButton.addEventListener("click", closeLightbox);

  lightbox.addEventListener("click", (event) => {
    if (event.target === lightbox) closeLightbox();
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeLightbox();
  });
});
