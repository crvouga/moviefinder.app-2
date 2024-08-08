import Swiper from "https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs";

class SwiperFeedElement extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });

    if (!this.shadowRoot) {
      throw new Error("Shadow DOM creation failed");
    }

    this.shadowRoot.innerHTML = `
      <div class="swiper">
        <div class="swiper-wrapper"></div>
      </div>
    `;

    const style = document.createElement("style");
    style.textContent = `
      :host {
        display: block;
        width: 100%;
        height: 100%;
        overflow: hidden;
      }
      .swiper {
        width: 100%;
        height: 100%;
      }
      .swiper-slide {
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 24px;
        background-color: #000;
        color: #fff;
        border-bottom: 1px solid #fff;
      }
    `;
    this.shadowRoot.appendChild(style);

    this.swiper = null;
  }

  connectedCallback() {
    if (!this.shadowRoot) {
      throw new Error("Shadow DOM creation failed");
    }

    if (typeof Swiper !== "undefined") {
      this.initializeSwiper();
    } else {
      window.addEventListener("load", () => this.initializeSwiper());
    }
  }

  initializeSwiper() {
    const slides = Array.from({ length: 1000 }, (_, i) => `Slide ${i + 1}`);

    let appendNumber = 600;
    let prependNumber = 1;
    this.swiper = new Swiper(this.shadowRoot.querySelector(".swiper"), {
      slidesPerView: 1,
      centeredSlides: true,
      spaceBetween: 30,
      direction: "vertical",
      virtual: {
        slides: (function () {
          const slides = [];
          for (var i = 0; i < 600; i += 1) {
            slides.push("Slide " + (i + 1));
          }
          return slides;
        })(),
      },
    });

    this.swiper.on("slideChange", () => {
      console.log("Current slide index:", this.swiper.activeIndex);
    });

    this.swiper.on("setTranslate", (translate) => {
      console.log("Current translate:", translate);
    });
  }
}

customElements.define("swiper-feed-element", SwiperFeedElement);
