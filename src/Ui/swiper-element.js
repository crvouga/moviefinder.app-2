// @ts-check

class SwiperElement extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });

    if (!this.shadowRoot) {
      throw new Error("Shadow DOM creation failed");
    }

    this.shadowRoot.innerHTML = `
      <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" />
      <div class="swiper-container">
        <div class="swiper-wrapper">
          <div class="swiper-slide">Slide 1</div>
          <div class="swiper-slide">Slide 2</div>
          <div class="swiper-slide">Slide 3</div>
        </div>
        <div class="swiper-pagination"></div>
        <div class="swiper-button-next"></div>
        <div class="swiper-button-prev"></div>
      </div>
    `;
    this.currentIndex = 0; // Internal state for current slide index
  }

  connectedCallback() {
    if (!this.shadowRoot) {
      throw new Error("Shadow DOM creation failed");
    }

    const swiper = new Swiper(
      this.shadowRoot.querySelector(".swiper-container"),
      {
        pagination: {
          el: this.shadowRoot.querySelector(".swiper-pagination"),
        },
        navigation: {
          nextEl: this.shadowRoot.querySelector(".swiper-button-next"),
          prevEl: this.shadowRoot.querySelector(".swiper-button-prev"),
        },
      }
    );

    swiper.on("slideChange", () => {
      this.currentIndex = swiper.activeIndex;

      // Trigger HTMX POST request
      htmx.ajax("POST", "/your-endpoint", {
        target: this,
        swap: "none",
        values: { index: this.currentIndex },
      });
    });
  }
}

customElements.define("swiper-element", SwiperElement);
